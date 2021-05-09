.SECONDEXPANSION:

.PHONY: dist
dist: dist/flightdeck.tgz dist/dex.tgz dist/flightdeck-ui.tgz

CHARTS     := $(wildcard charts/*)
CHARTSDIST := $(foreach chart,$(CHARTS),$(subst charts/,dist/,$(chart).tgz))

$(CHARTSDIST): dist/%.tgz: $$(wildcard charts/$$*/*.yaml) $$(wildcard charts/$$*/templates/*.yaml)
	mkdir -p dist
	helm package "charts/$*" --destination tmp
	mv tmp/$*-*.tgz "$@"

KUBECTL := kubectl --kubeconfig tmp/kubeconfig --context kind-flightdeck

.PHONY: local
local: tmp/chartmuseum tmp/metallb tmp/values.yaml tmp/ldap
	$(MAKE) -C local ops-cluster
	$(KUBECTL) config use-context kind-flightdeck
	KUBECONFIG=tmp/kubeconfig \
	FLIGHTDECK_REPO=http://chartmuseum.default.svc:8080 \
	bin/install tmp/values.yaml
	@echo "Flightdeck is available at https://$$(cat tmp/tunnel_host)"

tmp/chartmuseum: $(CHARTSDIST) tmp/kubeconfig
	$(KUBECTL) apply -f local/chartmuseum.yaml
	$(KUBECTL) wait \
		--for=condition=available \
		--timeout=90s \
		deploy/chartmuseum
	for f in dist/*.tgz; do \
		echo "Pushing $$f..."; \
		curl \
			--data-binary "@$$f" \
			--retry 3 \
			--retry-all \
			http://localhost:3000/api/charts?force \
			> /dev/null; \
		done
	touch tmp/chartmuseum

tmp/metallb: dist tmp/kubeconfig tmp/memberlist.yaml tmp/metallb-config.yaml
	$(KUBECTL) \
		apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/namespace.yaml
	$(KUBECTL) \
		apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/metallb.yaml
	$(KUBECTL) apply -f tmp/memberlist.yaml
	$(KUBECTL) apply -f tmp/metallb-config.yaml
	$(KUBECTL) wait \
		--for=condition=available \
		--timeout=90s \
		--namespace metallb-system \
		deploy/controller
	$(KUBECTL) wait \
		--for=condition=ready \
		--timeout=90s \
		--namespace metallb-system \
		--selector=component=speaker \
		pod
	touch tmp/metallb

tmp/memberlist.yaml: tmp/kubeconfig
	$(KUBECTL) \
		create secret generic \
		-n metallb-system \
		memberlist --from-literal=secretkey="$$(openssl rand -base64 128)" \
		--dry-run=client \
		-oyaml \
		> tmp/memberlist.yaml

tmp/metallb-config.yaml: tmp/kubeconfig tmp/address-pools
	$(KUBECTL) \
		create configmap \
		--namespace metallb-system \
		config \
		--from-file=config=tmp/address-pools \
		--dry-run=client \
		-oyaml \
		> tmp/metallb-config.yaml

tmp/address-pools: tmp/kind-cidr-start tmp/kind-cidr-end
	echo "address-pools:" > tmp/address-pools
	echo "- name: default" >> tmp/address-pools
	echo "  protocol: layer2" >> tmp/address-pools
	echo "  addresses:" >> tmp/address-pools
	echo "  - $$(cat tmp/kind-cidr-start)-$$(cat tmp/kind-cidr-end)" \
		>> tmp/address-pools

tmp/kind-cidr-start: tmp/kind-cidr
	echo "cidrhost(\"$$(cat tmp/kind-cidr)\", 100)" \
		| terraform console \
		| sed 's/"//g' \
		> tmp/kind-cidr-start

tmp/kind-cidr-end: tmp/kind-cidr
	echo "cidrhost(\"$$(cat tmp/kind-cidr)\", 200)" \
		| terraform console \
		| sed 's/"//g' \
		> tmp/kind-cidr-end

tmp/kind-cidr: tmp/kubeconfig
	docker network inspect -f '{{index .IPAM.Config 0 "Subnet"}}' kind \
		> tmp/kind-cidr

tmp/values.yaml: tmp/tunnel_host
	echo "ingress:\n  host: $$(cat tmp/tunnel_host)\n  requireTLS: false" \
		| cat - local/values.yaml \
		> tmp/values.yaml

tmp/tunnel_host: tmp/ngrok_ip
	curl "$$(cat tmp/ngrok_ip):4040/api/tunnels" \
		| jq -r '.tunnels[0].public_url' \
		| sed 's|https\?://||' \
		> tmp/tunnel_host

tmp/ngrok_ip: tmp/kubeconfig tmp/metallb
	$(KUBECTL) apply -f local/ngrok.yaml
	$(KUBECTL) wait \
		--for=condition=available \
		--timeout=90s \
		deploy/ngrok
	$(KUBECTL) get svc ngrok -ojsonpath='{.status.loadBalancer.ingress[0].ip}' \
		> tmp/ngrok_ip

tmp/kubeconfig:
	mkdir -p tmp
	if ! kind get clusters | grep -q flightdeck; then \
		kind create cluster --name flightdeck --config local/kind.yaml; \
		kind export kubeconfig \
		--name flightdeck \
		--kubeconfig tmp/kubeconfig; \
		fi

tmp/ldap: tmp/kubeconfig local/glauth/*.yaml
	$(KUBECTL) apply -f local/glauth
	touch tmp/ldap

.PHONY: kind-down
kind-down:
	if kind get clusters | grep -q flightdeck; then \
		kind delete cluster --name flightdeck; \
		rm tmp/kubeconfig; \
		fi

MODULES         := $(wildcard terraform/*/*)
MODULEMAKEFILES := $(foreach module,$(MODULES),$(module)/makefile)
VALIDATEMODULES := $(foreach module,$(MODULES),$(module)/validate)
CLEANMODULES    := $(foreach module,$(MODULES),$(module)/clean)

.PHONY: fmt
fmt:
	terraform fmt -recursive

.PHONY: validate
validate: $(VALIDATEMODULES)

$(VALIDATEMODULES): %/validate:
	$(MAKE) -C "$*" .validate

$(CLEANMODULES): %/clean:
	$(MAKE) -C "$*" clean

.PHONY: makefiles
makefiles: $(MODULEMAKEFILES)

$(MODULEMAKEFILES): %/makefile: makefiles/terraform.mk
	cp "$<" "$@"

.PHONY: clean
clean: kind-down $(CLEANMODULES)
	$(MAKE) -C local/ops-cluster clean
	rm -rf dist tmp

.SECONDEXPANSION:

.PHONY: default
default: modules local

KUBECTL := kubectl --kubeconfig tmp/kubeconfig --context kind-flightdeck

export TF_CLI_CONFIG_FILE := $(CURDIR)/.terraformrc

.PHONY: local
local: tmp/metallb tmp/tfvars.json tmp/ldap
	$(MAKE) -C local/operations-platform init
	$(MAKE) -C local/operations-platform TFVARS=$(PWD)/tmp/tfvars.json apply

tmp/metallb: tmp/kubeconfig tmp/memberlist.yaml tmp/metallb-config.yaml
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

tmp/tfvars.json: tmp/tunnel_host local/tfvars.json
	cat local/tfvars.json \
		| jq \
		--arg host "$$(cat tmp/tunnel_host)" \
		'. + {"host": $$host}' \
		> tmp/tfvars.json

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

MODULES         := $(wildcard aws/* common/*)
MODULEMAKEFILES := $(foreach module,$(MODULES),$(module)/makefile)
MAKEMODULES     := $(foreach module,$(MODULES),$(module)/default)
CLEANMODULES    := $(foreach module,$(MODULES),$(module)/clean)

.PHONY: fmt
fmt:
	terraform fmt -recursive

.PHONY: modules
modules: makefiles makemodules

.PHONY: makefiles
makefiles: $(MODULEMAKEFILES)

$(MODULEMAKEFILES): %/makefile: makefiles/terraform.mk
	cp "$<" "$@"

.PHONY: makemodules
makemodules: $(MAKEMODULES)

$(MAKEMODULES): %/default: .terraformrc
	$(MAKE) -C "$*"

$(CLEANMODULES): %/clean:
	$(MAKE) -C "$*" clean

.PHONY: clean
clean: kind-down $(CLEANMODULES)
	$(MAKE) -C local/operations-platform clean
	rm -rf tmp

.terraformrc:
	mkdir -p .terraform-plugins
	echo 'plugin_cache_dir = "$(CURDIR)/.terraform-plugins"' > .terraformrc

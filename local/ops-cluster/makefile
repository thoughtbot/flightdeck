CONFIG         ?= $(PWD)
BACKEND_CONFIG := backend.tfvars
STATE          := terraform.tfstate
TFVARS         ?= tfvars.json

export TF_DATA_DIR         := $(CONFIG)/.terraform
export TF_CLI_ARGS_init    := -backend-config=$(BACKEND_CONFIG)
export TF_CLI_ARGS_plan    := -var-file=$(TFVARS) -input=false -state=$(STATE)
export TF_CLI_ARGS_apply   := $(TF_CLI_ARGS_plan) -auto-approve
export TF_CLI_ARGS_destroy := $(TF_CLI_ARGS_plan)
export TF_CLI_ARGS_import  := $(TF_CLI_ARGS_plan)
export TF_CLI_ARGS_refresh := $(TF_CLI_ARGS_plan)

.PHONY: default
default: $(CONFIG)/applied

.PHONY: fmt
fmt:
	terraform fmt

.PHONY: plan
plan: clean_plan $(CONFIG)/plan

.PHONY: clean_plan
clean_plan:
	rm -f $(CONFIG)/plan

.PHONY: validate
validate:
	export TF_CLI_ARGS_init= terraform init -backend=false
	terraform validate

.PHONY: destroy
destroy:
	terraform destroy
	$(MAKE) clean

.PHONY: clean
clean:
	rm -rf $(CONFIG)/.terraform $(CONFIG)/initialized $(CONFIG)/applied
	rm -rf *tfstate*

.PHONY: clean_apply
clean_apply:
	rm -f $(CONFIG)/applied

.PHONY: apply
apply: clean_apply $(CONFIG)/applied

.PHONY: apply-saved
apply-saved: $(CONFIG)/initialized
	@if [ ! -f "$(CONFIG)/plan" ]; then \
		echo "No plan has been saved." 1>&2; \
		fi
	TF_CLI_ARGS_apply= terraform apply -state=$(STATE) "$(CONFIG)/plan"
	rm -f $(CONFIG)/plan
	touch $(CONFIG)/applied

.PHONY: shell
shell:
	"$${SHELL:-sh}"

.PHONY: init
init: clean $(CONFIG)/initialized

.PHONY: upgrade
upgrade:
	terraform init -upgrade=true
	touch $(CONFIG)/initialized

$(CONFIG)/applied: $(CONFIG)/initialized $(TFVARS) *.tf
	terraform apply
	rm -f $(CONFIG)/plan
	touch $(CONFIG)/applied

$(CONFIG)/plan: $(CONFIG)/initialized $(TFVARS) *.tf
	terraform plan -out $(CONFIG)/plan

$(CONFIG)/initialized: $(BACKEND_CONFIG) $(CONFIG)/dependencies
	terraform init
	touch $(CONFIG)/initialized

$(CONFIG)/dependencies: *.tf
	@if [ ! -d "$(CONFIG)" ]; then \
		echo "No such config: $(CONFIG)" 1>&2; \
		echo "Specify another config by passing CONFIG=name" 1>&2; \
		fi
	@grep -ohE \
		"\b(backend|provider|resource|module) ['\"][[:alpha:]][[:alnum:]]*" *.tf | \
		sed "s/['\"]//" | sort | uniq | \
		tee /tmp/initdeps | \
		diff -q $(CONFIG)/dependencies - >/dev/null 2>&1 || \
		mv /tmp/initdeps $(CONFIG)/dependencies

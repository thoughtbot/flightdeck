MODULEFILES := $(wildcard *.tf)

.PHONY: default
default: .fmt .validate

.PHONY: fmt
fmt: .fmt

.PHONY: validate
fmt: .validate

.fmt: $(MODULEFILES)
	terraform fmt
	@touch .fmt

.PHONY: init
init: .terraform

.terraform: providers.tf.json
	terraform init -backend=false

.validate: .terraform $(MODULEFILES)
	AWS_DEFAULT_REGION=us-east-1 terraform validate
	@touch .validate

.PHONY: clean
clean:
	rm -rf .fmt .terraform .validate

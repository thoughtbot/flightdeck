TFLINTRC    := ../../.tflint.hcl
MODULEFILES := $(wildcard *.tf)

.PHONY: default
default: checkfmt validate docs lint

.PHONY: checkfmt
checkfmt: .fmt

.PHONY: fmt
fmt: $(MODULEFILES)
	terraform fmt
	@touch .fmt

.PHONY: validate
validate: .validate

.PHONY: docs
docs: README.md

.PHONY: lint
lint: .lint

.lint: $(MODULEFILES) .lintinit
	tflint --config=$(TFLINTRC)
	@touch .lint

.lintinit: $(TFLINTRC)
	tflint --init --config=$(TFLINTRC) --module
	@touch .lintinit

README.md: $(MODULEFILES)
	terraform-docs markdown table . --output-file README.md

.fmt: $(MODULEFILES)
	terraform fmt -check
	@touch .fmt

.PHONY: init
init: .init

.init: providers.tf.json
	terraform init -backend=false
	@touch .init

.validate: .init $(MODULEFILES)
	AWS_DEFAULT_REGION=us-east-1 terraform validate
	@touch .validate

.PHONY: clean
clean:
	rm -rf .fmt .init .lint .lintinit .terraform .validate

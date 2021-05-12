MODULEFILES := $(wildcard *.tf)

.PHONY: fmt
fmt: .fmt

.fmt: $(MODULEFILES)
	terraform fmt
	@touch .fmt

.PHONY: init
init: .terraform

.terraform: $(MODULEFILES)
	terraform init -backend=false

.PHONY: validate
validate: .terraform
	AWS_DEFAULT_REGION=us-east-1 terraform validate

.PHONY: clean
clean:
	rm -f .fmt

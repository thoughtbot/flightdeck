.SECONDEXPANSION:

.PHONY: default
default: modules

export TF_CLI_CONFIG_FILE := $(CURDIR)/.terraformrc

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
clean: $(CLEANMODULES)
	rm -rf tmp

.terraformrc:
	mkdir -p .terraform-plugins
	echo 'plugin_cache_dir = "$(CURDIR)/.terraform-plugins"' > .terraformrc

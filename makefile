.SECONDEXPANSION:

export TF_CLI_CONFIG_FILE := $(CURDIR)/.terraformrc

MODULES         := $(wildcard aws/* common/*)
MODULEMAKEFILES := $(foreach module,$(MODULES),$(module)/makefile)
MAKEMODULES     := $(foreach module,$(MODULES),$(module)/default)
CLEANMODULES    := $(foreach module,$(MODULES),$(module)/clean)
CHART_PARAMS    := $(wildcard */*/chart.json)

.PHONY: default
default: $(CHART_PARAMS) modules

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

.PHONY: chartparams
chartparams: $(CHART_PARAMS)

$(CHART_PARAMS): charts.json
	jq \
		--arg target "$@" \
		'. as $$charts | $$target | split("/") as $$path | $$charts[$$path[0]][$$path[1]]' \
		< charts.json > "$@"

.PHONY: updatecharts
updatecharts:
	bin/update-charts

.PHONY: clean
clean: $(CLEANMODULES)
	rm -rf tmp

.terraformrc:
	mkdir -p .terraform-plugins
	echo 'plugin_cache_dir = "$(CURDIR)/.terraform-plugins"' > .terraformrc

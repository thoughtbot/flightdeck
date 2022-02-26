.SECONDEXPANSION:

export TF_CLI_CONFIG_FILE := $(CURDIR)/.terraformrc
export TFLINTRC := $(CURDIR)/.tflint.hcl
export TFDOCSRC := $(CURDIR)/.terraform-docs.yml

SUBMODULES         := $(filter-out \
	%.md,\
	$(wildcard \
		platform/modules/* \
		platform \
		aws/*/modules/*\
		aws/* \
		)\
	)
SUBMODULEMAKEFILES := $(foreach module,$(SUBMODULES),$(module)/makefile)
MAKESUBMODULES     := $(foreach module,$(SUBMODULES),$(module)/make)
SUBMODULESCOMMAND  ?= default
CHART_PARAMS       := $(wildcard */*/*/chart.json */*/*/*/chart.json)

.PHONY: default
default: chartparams submodules

include makefiles/tests.mk

.PHONY: chartparams
chartparams: $(CHART_PARAMS)

$(CHART_PARAMS): charts.json
	jq \
		--arg target "$@" \
		'. as $$charts | $$target | split("/") as $$path | $$charts[$$path[-2]]' \
		< charts.json > "$@"

.PHONY: submodules
submodules: $(SUBMODULEMAKEFILES) $(MAKESUBMODULES)

.PHONY: makefiles
makefiles: $(SUBMODULEMAKEFILES)

$(SUBMODULEMAKEFILES): %/makefile: makefiles/terraform.mk
	cp "$<" "$@"

$(MAKESUBMODULES): %/make: .terraformrc
	$(MAKE) -C "$*" "$(SUBMODULESCOMMAND)"

.PHONY: fmt
fmt: all/fmt

.PHONY: clean
clean: all/clean
	rm -rf tmp

$(CLEANMODULES): %/clean:
	$(MAKE) -C "$*" clean

.PHONY: updatecharts
updatecharts:
	bin/update-charts

.terraformrc:
	mkdir -p .terraform-plugins
	echo 'plugin_cache_dir = "$(CURDIR)/.terraform-plugins"' > .terraformrc

all/%:
	$(MAKE) submodules SUBMODULESCOMMAND=$(*)

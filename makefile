.SECONDEXPANSION:

export TF_CLI_CONFIG_FILE := $(CURDIR)/.terraformrc
export TFLINTRC := $(CURDIR)/.tflint.hcl

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

.PHONY: default
default: chartparams submodules

.PHONY: chartparams
chartparams: $(CHART_PARAMS)

$(CHART_PARAMS): charts.json
	jq \
		--arg target "$@" \
		'. as $$charts | $$target | split("/") as $$path | $$charts[$$path[0]][$$path[1]]' \
		< charts.json > "$@"

.PHONY: submodules
submodules: $(SUBMODULEMAKEFILES) $(MAKESUBMODULES)

$(SUBMODULEMAKEFILES): %/makefile: makefiles/terraform.mk
	@echo "$(SUBMODULEMAKEFILES)"
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

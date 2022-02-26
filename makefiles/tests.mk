TEST_FILES  := $(wildcard tests/*.bats)

export TEST_TMPDIR := $(CURDIR)/tmp
export TEST_DIR    := $(CURDIR)/tests

.PHONY: tests
tests: vendor/bin/bats
	vendor/bin/bats $(TEST_FILES)

.PHONY: $(TEST_FILES)
$(TEST_FILES): vendor/bin/bats
	vendor/bin/bats "$@"

vendor/bin/bats: tmp/bats
	mkdir -p vendor
	tmp/bats/install.sh ./vendor

tmp/bats:
	mkdir -p tmp
	git clone https://github.com/sstephenson/bats.git tmp/bats

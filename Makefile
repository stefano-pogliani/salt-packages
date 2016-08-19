.PHONY: build build-all clean clean-all kitchen test
.DEFAULT_GOAL := build-all

# Kitchen related options.
ACTION ?= converge
SALTIFY_PATH ?= ../salt-tools/bin/saltify

# Target a specific PACKAGE by name.
# Find the package FORMULA file and check.
PACKAGE ?= Please specify a package name
PACKAGE_FORMULA = $(shell find packages -name FORMULA -exec grep --silent 'name: $(PACKAGE)' '{}' ';' -print)
PACKAGE_DIR = $(shell dirname "$(PACKAGE_FORMULA)")

build:
	@[ -e "$(PACKAGE_FORMULA)" ] || \
		(echo "Could not find package '$(PACKAGE)'!" && exit 1)
	@echo "Building '$(PACKAGE)' ..."
	spm -c build/spm.conf.d build $(PACKAGE_DIR)

clean:
	@[ -e "$(PACKAGE_FORMULA)" ] || \
		(echo "Could not find package '$(PACKAGE)'!" && exit 1)
	rm -f out/$(PACKAGE)*

kitchen:
	@[ -e "$(PACKAGE_FORMULA)" ] || \
		(echo "Could not find package '$(PACKAGE)'!" && exit 1)
	@[ -e "$(PACKAGE_DIR)/.kitchen.yml" ] || \
		(echo "Package '$(PACKAGE)' does not have tests!" && exit 1)
	(. $(SALTIFY_PATH); cd "$(PACKAGE_DIR)"; kitchen $(ACTION))

test:
	$(MAKE) kitchen ACTION=test PACKAGE=$(PACKAGE)


# Target ALL packages.
build-all:
	@echo "Building all package ..."
	find packages -name FORMULA | while read package; do \
		spm -c build/spm.conf.d build "$$(dirname "$${package}")"; \
	done

clean-all:
	rm -f out/*

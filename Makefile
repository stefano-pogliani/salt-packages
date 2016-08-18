.PHONY: build build-all clean clean-all
.DEFAULT_GOAL := build-all


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


# Target ALL packages.
build-all:
	@echo "Building all package ..."
	find packages -name FORMULA | while read package; do \
		spm -c build/spm.conf.d build "$$(dirname "$${package}")"; \
	done

clean-all:
	rm -f out/*

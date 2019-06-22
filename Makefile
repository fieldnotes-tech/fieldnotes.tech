SHELL := /usr/bin/env bash
HUGO := hugo -v
DATE := $(shell date)
DOMAIN := fieldnotes.tech
ALLOW_DIRTY ?= NO

PUBLIC_REPO ?= git@github.com:fieldnotes-tech/fieldnotes-tech.github.io

SOURCE := $(shell find . -type f -not -path './.git/*' -not -path './public/*')

.PHONY: clean clean-submodules publish commit submodules clean-workspace test validate-circleci

default: publish

clean-submodules:
	rm -rf .gitmodules .git/modules/public public

clean:
	rm -rf public/*

publish: commit
	cd public && git push origin master

commit: public
	cd public && \
	if git diff --exit-code; then \
		echo "Nothing to commit."; \
	else \
		git add -A && git commit -m "publish: $(DATE)"; \
	fi

public: $(SOURCE) 
	rm -rf $@/*
	echo $(DOMAIN) > $@/CNAME
	$(HUGO)

build: clean-workspace submodules
	$(MAKE) public

EXCLUDE := .git/info/exclude

$(EXCLUDE): Makefile
	[ -f $@ ] || touch $@
	grep -E $@ '^.gitmodules$$' || echo .gitmodules >> $(EXCLUDE)

submodules:
	mv $(EXCLUDE) $(EXCLUDE).not
	git submodule add --force -b master $(PUBLIC_REPO) public
	git config submodule.public.ignore all
	git reset public/
	git submodule update --recursive --remote
	git reset .gitmodules
	mv $(EXCLUDE).not $(EXCLUDE)


clean-workspace:
	@if [ $(ALLOW_DIRTY) != YES ] && [ -n "$$(git status -s)" ]; then echo "[ERR] Workspace dirty."; exit 1; fi

test: validate-circleci
	@echo "All tests passed."

validate-circleci:
	circleci config validate

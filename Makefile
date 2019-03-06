SHELL := /usr/bin/env bash
HUGO := hugo -v
DATE := $(shell date)
DOMAIN := fieldnotes.tech
ALLOW_DIRTY ?= NO

PUBLIC_REPO ?= git@github.com:fieldnotes-tech/fieldnotes-tech.github.io

# SSH_PRIVATE_KEY used for local testing of circleci.
SSH_PRIVATE_KEY_FILE ?= ~/.ssh/fieldnotes-tech-rsa

.PHONY: publish commit public submodules clean-workspace

publish: commit
	cd public && git push origin master

commit: public
	cd public && \
	if git diff --exit-code; then \
		echo "Nothing to commit."; \
	else \
		git add -A && git commit -m "publish: $(DATE)"; \
	fi

public: clean-workspace submodules
	rm -rf $@/*
	echo $(DOMAIN) > $@/CNAME
	$(HUGO)

submodules:
	git submodule add --force -b master $(PUBLIC_REPO) public
	git config submodule.public.ignore all
	git reset public/
	git submodule update --recursive --remote

clean-workspace:
	@if [ $(ALLOW_DIRTY) != YES ] && [ -n "$$(git status -s)" ]; then echo "[ERR] Workspace dirty."; exit 1; fi

test: test-circleci
	@echo "All tests passed."

test-circleci:
	circleci local execute -e SSH_PRIVATE_KEY="$$(<$(SSH_PRIVATE_KEY_FILE))"

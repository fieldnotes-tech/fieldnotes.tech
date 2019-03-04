SHELL := /usr/bin/env bash
HUGO := hugo
DATE := $(shell date)
DOMAIN := fieldnotes.tech
KISS_THEME_REVISION := 55f6f0068e8304bf7ac848e68f918912bd8d5336

.PHONY: publish commit public kiss-theme submodules clean-workspace

publish: commit
	cd public && git push origin master

commit: public
	cd public && \
	if git diff --exit-code; then \
		echo "Nothing to commit."; \
	else \
		git add -A && git commit -m "publish: $(DATE)"; \
	fi

public: clean-workspace submodules kiss-theme
	rm -rf $@/*
	echo $(DOMAIN) > $@/CNAME
	$(HUGO)

kiss-theme: submodules
	cd themes/kiss && git reset --hard $(KISS_THEME_REVISION)

submodules:
	git submodule add --force -b master git@github.com:fieldnotes-tech/fieldnotes-tech.github.io public
	git config submodule.public.ignore all
	git reset public/
	git submodule update --recursive --remote

clean-workspace:
	@if [ ! -z "$$(git status -s)" ]; then echo "[ERR] Workspace dirty."; exit 1; fi

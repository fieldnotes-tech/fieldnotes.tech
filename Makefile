SHELL := /usr/bin/env bash
HUGO := hugo
DATE := $(shell date)
KISS_THEME_REVISION := 55f6f0068e8304bf7ac848e68f918912bd8d5336

.PHONY: publish commit public clean-workspace

publish: commit
	cd public && git push origin master

commit: public
	cd public && \
	if git diff --exit-code; then \
		echo "Nothing to commit."; \
	else \
		git add -A && git commit -m "publish: $(DATE)"; \
	fi

public: clean-workspace
	git submodule update --recursive --remote
	cd themes/kiss && git reset --hard $(KISS_THEME_REVISION)
	rm -rf $@/*
	echo fieldnotes.tech > $@/CNAME
	$(HUGO)

clean-workspace:
	@if [ ! -z "$$(git status -s)" ]; then echo "[ERR] Workspace dirty."; exit 1; fi

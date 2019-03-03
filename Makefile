HUGO := hugo
DATE := $(shell date)
SHELL := /usr/bin/env bash

.PHONY: publish commit build public clean-workspace

publish: commit
	cd public && git push origin gh-pages

commit: public
	cd public && \
	if git diff --exit-code; then \
		echo "Nothing to commit."; \
	else \
		git add -A && git commit -m "publish: $(DATE)"; \
	fi

public: clean-workspace
	if [ -d $@ ]; then rm -rf $@; fi
	if [ -f $@ ]; then echo "[ERR] ./$@ is a file."; exit 1; fi
	mkdir $@
	git worktree prune
	rm -rf .git/worktrees/public
	git worktree add -B gh-pages public origin/gh-pages
	rm -rf $@/*
	echo fieldnotes.tech > $@/CNAME
	$(HUGO)

clean-workspace:
	[ -z "$(git status -s)" ] || { echo "[ERR] Workspace dirty."; exit 1; }

---
title: "Hugo Makefile"
date: 2019-03-03T22:37:00Z
tags:
- hugo
- make
- meta
aliases:
- /posts/hugo-makefile/
---

This blog is hosted on [GitHub Pages](https://pages.github.com)
and published using [Hugo](https://gohugo.io).
Since Go is my preferred language at the moment, Hugo seemed attractive.

There are 2 Git repos for this website:

- Source code:
[github.com/fieldnotes-tech/fieldnotes.tech](https://github.com/fieldnotes-tech/fieldnotes.tech)
- Rendered static site:
[github.com/fieldnotes-tech/fieldnotes-tech.github.io](https://github.com/fieldnotes-tech/fieldnotes-tech.github.io)

Publishing involves updating the source,
and having Hugo generate the static site.
To make this easier to use I've added a `Makefile`
which pulls the rendered site as a submodule
in the `public/` directory,
which is Hugo's default place to write the rendered site.
It also pulls the [kiss theme](https://github.com/ribice/kiss)'s submodule,
and ensures it's set to a specific revision.
(I don't want to be surprised if this gets broken in some way later.)

This Makefile works fine on my dev machine,
but will need some refinement for the next phase:
having the site regenerated in CI on every push.
Some issues that will need to be solved are:

- It presumes the `hugo` command is already installed,
- It does not assert which version of Hugo should be used.

Here is the Makefile as it stands right now...

```Makefile
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
	git submodule update --recursive --remote

clean-workspace:
	@if [ ! -z "$$(git status -s)" ]; then echo "[ERR] Workspace dirty."; exit 1; fi
```

Next up: getting this website built in CI on every push...

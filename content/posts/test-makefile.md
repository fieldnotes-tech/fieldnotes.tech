---
title: "Test Makefile"
date: 2019-03-03T17:15:11Z
draft: true
---

I just added this simple Makefile ... does it work?

```
HUGO := hugo

publish: push

push: commit
	cd public && git push origin gh-pages

commit: build
	cd public && git add -A && git commit -m "publish: $(DATE)"

build:
	$(HUGO)
```

That didn't, as it fails when there's nothing to commit.
Need to handle empty diffs.

Will this one be better?

```
HUGO := hugo

publish: push

push: commit
	cd public && git push origin gh-pages

commit: build
	cd public && \
	if git diff --exit-code; then \
		git add -A && git commit -m "publish: $(DATE)"; \
	fi

build:
	$(HUGO)
```

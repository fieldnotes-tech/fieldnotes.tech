HUGO := hugo
DATE := $(shell date)

publish: push

push: commit
	cd public && git push origin gh-pages

commit: build
	cd public && \
	if git diff --exit-code; then \
		echo "Nothing to commit."; \
	else \
		git add -A && git commit -m "publish: $(DATE)"; \
	fi

build:
	$(HUGO)

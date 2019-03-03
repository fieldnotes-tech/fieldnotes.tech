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

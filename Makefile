
HUGO := hugo

publish: push

push: commit
	cd public && git push origin gh-pages

commit: build
	cd public && git add -A && git commit -m "publish: $(DATE)"

build:
	$(HUGO)

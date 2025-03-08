.PHONY: live unpublished drafts

live:
	cd docs && bundle exec jekyll serve --livereload

unpublished:
	cd docs && bundle exec jekyll serve --unpublished

drafts:
	cd docs && bundle exec jekyll serve --drafts

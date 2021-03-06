.PHONY: all clean uninstall install release force_release

all:
	@grep -Ee '^[a-z].*:' Makefile | cut -d: -f1 | grep -vF all

clean:
	rm -rf build/ dist/ *.egg-info/

uninstall: clean
	@echo pip uninstalling expm
	$(shell pip uninstall -y etio-dashboard >/dev/null 2>/dev/null)
	$(shell pip uninstall -y etio-dashboard >/dev/null 2>/dev/null)
	$(shell pip uninstall -y etio-dashboard >/dev/null 2>/dev/null)

install: uninstall
	python setup.py install

release: clean
	# Check if latest tag is the current head we're releasing
	echo "Latest tag = $$(git tag | sort -nr | head -n1)"
	echo "HEAD SHA       = $$(git sha head)"
	echo "Latest tag SHA = $$(git tag | sort -nr | head -n1 | xargs git sha)"
	@test "$$(git sha head)" = "$$(git tag | sort -nr | head -n1 | xargs git sha)"
	make force_release

force_release: clean
	git push --tags
	python setup.py sdist bdist_wheel
	twine upload dist/*

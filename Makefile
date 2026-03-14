QUARTO := quarto
QUARTO_PYTHON := $(CURDIR)/.venv/bin/python
TO ?= html

.PHONY: render render-file preview check

render:
	QUARTO_PYTHON="$(QUARTO_PYTHON)" $(QUARTO) render --to "$(TO)"

render-file:
	@if [ -z "$(FILE)" ]; then \
		echo 'Usage: make render-file FILE=modules/01-foundations-modern-optimization.qmd'; \
		exit 1; \
	fi
	QUARTO_PYTHON="$(QUARTO_PYTHON)" $(QUARTO) render "$(FILE)" --to "$(TO)"

preview:
	QUARTO_PYTHON="$(QUARTO_PYTHON)" $(QUARTO) preview

check:
	QUARTO_PYTHON="$(QUARTO_PYTHON)" $(QUARTO) check
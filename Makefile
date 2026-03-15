QUARTO := quarto
QUARTO_PYTHON := $(CURDIR)/.venv/bin/python
TO ?= html
PROFILE ?= $(TO)

.PHONY: render render-all render-file preview check

render:
	QUARTO_PYTHON="$(QUARTO_PYTHON)" $(QUARTO) render --profile "$(PROFILE)" --to "$(TO)"

render-all:
	$(MAKE) render TO=html PROFILE=html
	$(MAKE) render TO=pdf PROFILE=pdf

render-file:
	@if [ -z "$(FILE)" ]; then \
		echo 'Usage: make render-file FILE=modules/01-foundations-modern-optimization.qmd'; \
		exit 1; \
	fi
	QUARTO_PYTHON="$(QUARTO_PYTHON)" $(QUARTO) render "$(FILE)" --profile "$(PROFILE)" --to "$(TO)"

preview:
	QUARTO_PYTHON="$(QUARTO_PYTHON)" $(QUARTO) preview --profile html

check:
	QUARTO_PYTHON="$(QUARTO_PYTHON)" $(QUARTO) check
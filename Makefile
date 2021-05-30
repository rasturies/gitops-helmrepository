charts_dir = charts
charts = $(shell find ${charts_dir} -mindepth 1 -maxdepth 1 -type d)

.PHONY: pre-commit autodoc

pre-commit: autodoc

autodoc:
	@echo "~~~~~[ Autodoc ]~~~~~"
	@docker run --rm -u $(shell id -u) -v $(shell pwd):/helm -w /helm jnorwood/helm-docs:v1.5.0 \
		--template-files=README.md.gotmpl --chart-search-root=./${charts_dir}
    
	@echo "Generating table of contents for charts..."
	@sed -i '/^## Charts/Q' README.md
	@echo -e "## Charts\n" >> README.md
	@find ./${charts_dir} -name README.md | sed "s/\.\/${charts_dir}\/\(.*\)\/README.md/- [\1](.\/${charts_dir}\/\1\/README.md)/g" >> README.md
	@ git add \*README.md


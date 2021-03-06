include make/*.mk

dev: ## Start rojo and any other dev necessary process
	rojo serve

docs-deploy: ## Build and deploy docs from current repo
	mkdocs gh-deploy

lint: ## Lint
	luacheck src

test: ## Test
	lua -lluacov spec.lua
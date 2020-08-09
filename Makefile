.PHONY: build clean help
.DEFAULT_GOAL := help

all: build compile clean ## Build, compile, and clean

build: ## Build docker image
	@docker build . -t latex

compile: build ## Compile resume.tex into a pdf
	@docker run --rm --name latex \
		-v ${PWD}:/tmp/ \
		-w /tmp/current/ \
		latex \
		xelatex resume.tex

clean: ## Clean up the repo
	@git clean -fdx

help: Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

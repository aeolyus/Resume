.PHONY: all build compile clean help
.DEFAULT_GOAL := help

SRCDIR := current
SRC := $(wildcard $(SRCDIR)/*.tex)
OBJ := $(SRC:.tex=.pdf)

all: compile clean ## Build, compile, and clean

build: Dockerfile ## Build docker image
	@docker build . -t latex

compile: build $(OBJ) ## Compile resume.tex into a pdf

$(OBJ): $(SRC)
	@docker run --rm --name latex \
		-v $(CURDIR):/tmp/ \
		-w /tmp/ \
		latex \
		latexmk -xelatex -pvc -view=none -output-directory=$(SRCDIR) $(SRC)

clean: ## Clean up the repo
	@git clean -fdx

help: Makefile ## Print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

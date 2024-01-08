SRCDIR := current
SRC := $(wildcard $(SRCDIR)/*.tex)
OBJ := $(SRC:.tex=.pdf)
.PRECIOUS: $(OBJ)

default: help

.PHONY: compile
compile: $(OBJ) ## Compile resume.tex into a pdf

.PHONY: build
build: Dockerfile ## Build docker image
	@docker build . -t latex

$(OBJ): $(SRC)
	@docker run --rm --name latex \
		-v $(CURDIR):/tmp/ \
		-w /tmp/ \
		aeolyus/resume-latex \
		latexmk -xelatex -pvc -view=none -output-directory=$(SRCDIR) $(SRC)

.PHONY: clean
clean: ## Clean up the repo
	@git clean -fdx

.PHONY: clean
help: Makefile ## Print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

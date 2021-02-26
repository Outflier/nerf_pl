CUDAGL_TAG='10.1-devel-ubuntu18.04'
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.DELETE_ON_ERROR:
.SUFFIXES:

WORKDIR = ~/workdir/nerf_pl
REPO = nerf_pl
DIR = nerf_pl
DOCKERFILE = ./Dockerfile
VERSION = latest

.PHONY: help
help:
	$(info Available make targets:)
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

.PHONY: build
build: ## Build docker image
	$(info *** Building docker image: $(REPO):$(VERSION))
	@docker build \
    --build-arg CUDAGL_TAG=$(CUDAGL_TAG) \
		--tag $(REPO):$(VERSION) \
		--file $(DOCKERFILE) \
		.

.PHONY: notebook
notebook: ## Launch a notebook
	$(info *** Launch a serving server on requested port)
	@docker run --rm -ti \
    --name nerfpl_notebook \
		--volume $(WORKDIR):/workdir \
    --volume /mnt/hdd/data:/workdir/data \
		--detach \
		--shm-size "32G" \
		--publish 8887:8888 \
		$(REPO):$(VERSION) jupyter notebook

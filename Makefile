TAG ?= 2.4.0

init: init-racetrack-submodule setup

setup:
	python3 -m venv venv &&\
	. venv/bin/activate &&\
	pip install --upgrade pip setuptools &&\
	cd docker-http &&\
	( cd proxy_wrapper && make setup ) &&\
	( cd racetrack/racetrack_client && make setup ) &&\
	( cd racetrack/racetrack_commons && make setup ) &&\
	( cd racetrack/utils/plugin_bundler && make setup )
	@echo Activate your venv:
	@echo . venv/bin/activate

build:
	cd docker-http &&\
	DOCKER_BUILDKIT=1 docker build \
		-t racetrack/fatman-base/docker-http:latest \
		-f base.Dockerfile .

bundle:
	cd docker-http &&\
	racetrack-plugin-bundler bundle --plugin-version=${TAG} --out=..

init-racetrack-submodule:
	git submodule update --init --recursive

update-racetrack-submodule:
	git submodule update --remote

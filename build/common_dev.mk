# Fallback to go 1.12.4
GO_VERSION ?= 1.12.4

# Docker image name
DOCKER_BASE_IMAGE=$(TEAM_NAME)/$(APP_NAME):base
DOCKER_IMAGE=$(TEAM_NAME)/$(APP_NAME)

# build args for Dockerfile's
DOCKER_RUN_DEV=@docker run --rm -i \
	-v `pwd`/$(APP_ROOT):/$(APP_NAME) \
	-w /$(APP_NAME)

# Verifies env variable is not empty
check-%:
	@if [ -z '${${*}}' ]; then echo 'Environment variable $* not set' && exit 1; fi

.PHONY: build-base
build-base:
	@echo "::: building base image"
	@docker build -f build/Base.Dockerfile \
	--build-arg GO_VERSION=${GO_VERSION}  \
	-t $(DOCKER_BASE_IMAGE) .

.PHONY: push-base
push-base:
	@echo "::: pushing base image to registry"
	@docker push $(DOCKER_BASE_IMAGE)

.PHONY: clean
clean:
	@echo "::: cleaning up project"
	@rm -rf vendor
	@docker image rm $(DOCKER_BASE_IMAGE)

.PHONY: unit-test
unit-test:
	@echo "::: running unit tests"
	$(DOCKER_RUN_DEV) $(DOCKER_BASE_IMAGE) sh -c "go test -v ./..."

.PHONY: lint
lint:
	@echo "::: running code lint"
	$(DOCKER_RUN_DEV) $(DOCKER_BASE_IMAGE) sh -c "golangci-lint run ./... --config=build/.golangci.yml"

.PHONY: cover
cover:
	@echo "::: generating go coverage report"
	$(DOCKER_RUN_DEV) $(DOCKER_BASE_IMAGE) sh -c "go test ./... -coverprofile=../c.out && go tool cover -html=../c.out -o ../coverage.html && cat ../coverage.html" > coverage.html
ifeq ($(shell uname -s),Linux)
	xdg-open coverage.html
else
	open coverage.html
endif

.PHONY: run
run: check-CMD
	@echo "::: running command inside container"
	$(DOCKER_RUN_DEV) $(DOCKER_BASE_IMAGE) sh -c "$(CMD)"

.PHONY: deps
deps:
	@echo "::: installing golang dependencies"
	$(DOCKER_RUN_DEV) $(DOCKER_BASE_IMAGE) sh -c "go mod tidy"

.PHONY: mocks
mocks:
	$(DOCKER_RUN_DEV) $(DOCKER_BASE_IMAGE) sh -c "go generate ./..."

# base tag for docker image
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')
DOCKER_BASE_IMAGE=$(TEAM_NAME)/$(APP_NAME):base
IMAGE_NAME=$(TEAM_NAME)/$(APP_NAME)
DOCKER_RUN?=docker run --rm -i

.PHONY: build-ci
build-ci:
	@docker build \
		--build-arg DOCKER_BASE_IMAGE=$(DOCKER_BASE_IMAGE) \
		-f build/CI.Dockerfile -t $(IMAGE_NAME):ci-$(COMMIT) .

.PHONY: unit-test-ci
unit-test-ci:
	$(DOCKER_RUN) $(IMAGE_NAME):ci-$(COMMIT) sh -c "go test ./... -v -race | go-junit-report" > report.xml

.PHONY: lint-ci
lint-ci:
	$(DOCKER_RUN) $(IMAGE_NAME):ci-$(COMMIT) sh -c "golangci-lint run ./... --config=.golangci.yml"

.PHONY: lint-lll
lint-lll:
	$(DOCKER_RUN) $(IMAGE_NAME):ci-$(COMMIT) sh -c "lll -s vendor .git mocks -l 100 -g -e '//' ."

.PHONY: cover-ci
cover-ci:
	$(DOCKER_RUN) $(IMAGE_NAME):ci-$(COMMIT) sh -c "go test ./... -coverprofile=../c.out && go tool cover -html=../c.out -o ../coverage.html && cat ../coverage.html" > coverage.html

.PHONY: clean-images
clean-images:
	@docker system prune -a -f

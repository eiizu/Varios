.PHONY: build-app
build-app:
	@docker build --no-cache -f build/Build.Dockerfile \
	 --build-arg BUILD_TIME=$(BUILD_TIME) \
	 --build-arg COMMIT=$(COMMIT) \
	 --build-arg IMAGE_NAME=$(IMAGE_NAME) \
	 --build-arg APP_ROOT=$(APP_ROOT) \
	 --build-arg APP_NAME=$(APP_NAME) \
	 -t $(IMAGE_NAME):$(COMMIT) .

.PHONY: push-image
push-image:
	docker push $(IMAGE_NAME):$(COMMIT)

.PHONY: get-image-label
get-image-label: ## Print image label
	@echo $(IMAGE_NAME):$(COMMIT)

.PHONY: get-image-tag
get-image-tag: ## Print image tag
	@echo $(COMMIT)

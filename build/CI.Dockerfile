ARG DOCKER_BASE_IMAGE
FROM ${DOCKER_BASE_IMAGE}

WORKDIR /app

# declare the environment variable PORT=8080
ENV PORT=8080
# expose the :8080 port to outside world from the container
EXPOSE 8080

COPY . /app

RUN go mod tidy

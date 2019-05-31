# Accept the Go version for the image to be set as a build argument.
# Default to Go 1.11.5
ARG GO_VERSION=1.12.4

# First stage: build the executable.
FROM golang:${GO_VERSION} AS base

# Dev dependencies
RUN go get github.com/stretchr/testify
RUN go get github.com/vektra/mockery/.../
RUN go get github.com/pilu/fresh
RUN go get github.com/derekparker/delve/cmd/dlv
RUN go get github.com/jstemmer/go-junit-report
RUN go get github.com/walle/lll/...
RUN curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s v1.14.0

# ssh keys for bithub
# private repos workaround
COPY build/.ssh /root/.ssh
RUN chmod 600 /root/.ssh/id_rsa && chmod 644 /root/.ssh/id_rsa.pub
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN git config --global url."git@github.com:".insteadOf "https://github.com/"

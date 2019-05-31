ARG IMAGE_NAME
ARG COMMIT
FROM ${IMAGE_NAME}:ci-${COMMIT} as build

ARG COMMIT
ARG BUILD_TIME
RUN CGO_ENABLED=0 GOOS=linux go build \
  -ldflags "-s -w -X main/version.Commit=${COMMIT} -X main/version.BuildTime=${BUILD_TIME}" \
  -a -installsuffix cgo -o app .

# Build image with binary
FROM scratch

WORKDIR /root/
COPY --from=build /app .
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

ENTRYPOINT ["./app"]
EXPOSE 8080

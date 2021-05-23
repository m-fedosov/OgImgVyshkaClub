FROM golang:1.16-alpine3.13 AS builder

ENV GOOS=linux
ENV CGO_CFLAGS_ALLOW="-Xpreprocessor"

RUN apk add --no-cache go gcc g++ vips-dev
COPY . /build
WORKDIR /build
RUN go get ./...
RUN go build -a -o /build/app -ldflags="-s -w -h" ./cmd/ogimgd

FROM alpine:3.13
RUN apk --no-cache add ca-certificates mailcap vips
COPY --from=builder /build/app /app/ogimgd
WORKDIR /app

ENTRYPOINT ["/app/ogimgd"]
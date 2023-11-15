FROM golang:buster as builder

RUN apk update && apk add alpine-sdk git && rm -rf /var/cache/apk/*

# Create app directory
WORKDIR /app

# Copy app dependencies
COPY go.mod .
COPY go.sum .
RUN go mod download

# Build executable binary
COPY server.go .
RUN go build -o ./server ./server.go

FROM debian:buster-slim
RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates
RUN rm -rf /var/lib/apt/lists/*

# Create app directory

# Copy static executable
COPY --from=builder /app/server /app/server

# Run the server binary
EXPOSE 9000
ENTRYPOINT ["./server"]
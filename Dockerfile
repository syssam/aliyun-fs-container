FROM golang:buster as builder

# Create app directory
WORKDIR /app

# Copy app dependencies
COPY go.* ./
RUN go mod download

# Build executable binary
COPY . ./

RUN go build -v -o server

FROM debian:buster-slim
RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates
RUN rm -rf /var/lib/apt/lists/*

# Create app directory

# Copy static executable
COPY --from=builder /app/server /app/server

# Run the server binary
EXPOSE 9000
ENTRYPOINT ["./server"]
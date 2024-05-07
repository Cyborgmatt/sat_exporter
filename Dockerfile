# Stage 1: Build the Go application
FROM golang:1.19 AS builder
WORKDIR /app

# Copy and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source files and build the binary
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /app/bin/server

# Stage 2: Create a minimal runtime image
FROM alpine:latest
WORKDIR /app

# Install any necessary packages, e.g., CA certificates for HTTPS connections
RUN apk --no-cache add ca-certificates

# Copy the built binary and relevant files from the builder stage
COPY --from=builder /app/bin/server /app/server

# Define the executable to run
CMD ["./server"]

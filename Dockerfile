# Use a lightweight base image
FROM golang:1.22.2 AS builder

# Set the working directory
WORKDIR /app

COPY go.mod ./
RUN go mod download
# Copy your Go source code to the container
COPY . .

# Build your Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o server ./apps

# Use a minimal base image for the final image
FROM alpine:latest

# Set the working directory
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/server .

# Expose the port your application will run on
EXPOSE 8081

# Start your Go application
CMD ["./server"]
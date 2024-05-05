FROM golang:1.19 AS builder

# Set the working directory
WORKDIR /app

# Copy the Go modules files
COPY go.mod .

# Download dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN GOOS=linux GOARCH=arm go build -o app

# Second stage: runtime environment
FROM golang:1.19-alpine

WORKDIR /app

# Copy the built executable from the previous stage
COPY --from=builder /app/app .

RUN apk add --update curl

# Expose port 8080
EXPOSE 8080

# Command to run the application
CMD ["/app/app"]
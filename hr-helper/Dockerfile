FROM golang:1.25 AS builder

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY cmd cmd
COPY internal internal

ENV CGO_ENABLED=0
RUN go build -o hr-helper ./cmd/hr-helper/main.go

FROM alpine:latest

RUN apk update

COPY configs configs
RUN mkdir -p .postgresql && \
wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" \
     --output-document .postgresql/root.crt && \
chmod 0655 .postgresql/root.crt


COPY --from=builder /app/hr-helper hr-helper

EXPOSE 8086

CMD ["./hr-helper"]

FROM golang:1.10-alpine as build

RUN apk --no-cache --update add git bash curl wget openssl libstdc++ protobuf boost icu && \
    rm -rf /var/cache/apk/*

WORKDIR /go/src/github.com/lyft/ratelimit
COPY . /go/src/github.com/lyft/ratelimit

RUN ./script/install-glide && \
    ./script/install-protoc && \
    glide install

RUN go build -o /usr/local/bin/ratelimit /go/src/github.com/lyft/ratelimit/src/service_cmd/main.go

FROM alpine:3.6

COPY --from=build /usr/local/bin/ratelimit /usr/local/bin/ratelimit

EXPOSE 8080
EXPOSE 6070

CMD /usr/local/bin/ratelimit

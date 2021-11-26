FROM golang:alpine AS build_base

RUN apk add --no-cache git gcc ca-certificates libc-dev
RUN mkdir -p /go/src/github.com/librespeed/speedtest-go
WORKDIR /go/src/github.com/librespeed/speedtest-go
ADD . .
RUN go get ./ && go build -ldflags "-w -s" -trimpath -o speedtest main.go

FROM alpine:3.9

RUN apk add ca-certificates
WORKDIR /app
COPY --from=build_base /go/src/github.com/librespeed/speedtest-go/speedtest .
COPY --from=build_base /go/src/github.com/librespeed/speedtest-go/web/assets ./assets
COPY --from=build_base /go/src/github.com/librespeed/speedtest-go/settings.toml .

EXPOSE 8989

CMD ["./speedtest"]

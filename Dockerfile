ARG ARCH
FROM golang AS gobuild

ARG GOARCH
ARG GOARM

RUN go get -v github.com/cloudflare/cloudflared/cmd/cloudflared
WORKDIR /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared

RUN GOARCH=${GOARCH} GOARM=${GOARM} go build ./

ARG ARCH
FROM multiarch/alpine:${ARCH}-edge

RUN apk add --no-cache ca-certificates

COPY --from=gobuild /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared/cloudflared /usr/local/bin/cloudflared

ENTRYPOINT [ "cloudflared" ]
CMD proxy-dns

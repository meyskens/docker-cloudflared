FROM golang AS gobuild

RUN go get -v github.com/cloudflare/cloudflared/cmd/cloudflared
WORKDIR /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared

RUN GOARCH=${GOARCH} GOARM=${GOARM} go build ./

ARG arch
FROM multiarch/alpine:${arch}-edge

COPY --from=gobuild /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared/cloudflared /usr/local/bin/cloudflared

ENTRYPOINT [ "cloudflared" ]
CMD proxy-dns

ARG ARCH
FROM golang AS gobuild

ARG GOARCH
ARG GOARM

RUN go get -v github.com/cloudflare/cloudflared/cmd/cloudflared
WORKDIR /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared

RUN CGO_ENABLED=0 GOARCH=${GOARCH} GOARM=${GOARM} go build -a -installsuffix cgo ./

ARG ARCH
FROM multiarch/alpine:${ARCH}-edge

RUN apk add --no-cache ca-certificates

COPY --from=gobuild /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared/cloudflared /usr/local/bin/cloudflared

CMD [ "cloudflared", "proxy-dns", "--address", "0.0.0.0" ]

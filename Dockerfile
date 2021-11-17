FROM alpine:latest

COPY entrypoint.sh /
RUN apk add --no-cache ca-certificates curl &&chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
FROM alpine:3.5

RUN apk --no-cache add \
    su-exec \
    ca-certificates \
    sqlite \
    bash \
    git \
    linux-pam \
    s6 \
    curl \
    openssh \
    tzdata
RUN addgroup \
    -S -g 1000 \
    git && \
  adduser \
    -S -H -D \
    -h /data/git \
    -s /bin/bash \
    -u 1000 \
    -G git \
    git && \
  echo "git:$(date +%s | sha256sum | base64 | head -c 32)" | chpasswd

COPY docker /
COPY gitea /app/gitea/gitea
COPY custom /app/gitea/custom

ENV USER git
ENV GITEA_CUSTOM /app/gitea/custom
ENV GODEBUG=netdns=go

VOLUME ["/data"]

EXPOSE 22 3000

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]


FROM debian:bookworm-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates build-essential libssl-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 https://github.com/TelegramMessenger/MTProxy.git /src
WORKDIR /src
RUN make

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl openssl libssl3 zlib1g && rm -rf /var/lib/apt/lists/*
WORKDIR /opt/mtproxy
COPY --from=build /src/objs/bin/mtproto-proxy ./mtproto-proxy
COPY start.sh ./start.sh
RUN chmod 0755 ./start.sh && useradd --system --no-create-home --shell /usr/sbin/nologin nobody || true
EXPOSE 443/tcp
ENTRYPOINT ["/opt/mtproxy/start.sh"]

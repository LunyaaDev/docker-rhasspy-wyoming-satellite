FROM debian:latest AS download

ARG SATELLITE_VERSION

RUN apt-get update && \
    apt-get install --yes --no-install-recommends curl ca-certificates

WORKDIR /data
RUN curl -L -o release.tar.gz \
    https://github.com/rhasspy/wyoming-satellite/archive/refs/tags/${SATELLITE_VERSION}.tar.gz && \
    mkdir source && tar -xzf release.tar.gz -C source --strip-components=1



FROM python:3.11-slim-bookworm

ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends avahi-utils alsa-utils

WORKDIR /app

COPY --from=download /data/source/sounds/ ./sounds/
COPY --from=download /data/source/script/setup ./script/
COPY --from=download /data/source/pyproject.toml ./
COPY --from=download /data/source/wyoming_satellite/ ./wyoming_satellite/

RUN script/setup

RUN .venv/bin/pip3 install 'webrtc-noise-gain==1.2.3'

COPY --from=download /data/source/script/run ./script/
COPY --from=download /data/source/docker/run ./

EXPOSE 10700

ENTRYPOINT ["/app/run"]

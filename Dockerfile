FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

# add debs folder
COPY jellyfin-debs/ /jellyfin-debs

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    gnupg && \
  echo "**** install jellyfin *****" && \
  echo 'deb [trusted=yes] file:/jellyfin-debs ./' > /etc/apt/sources.list.d/jellyfin.list && \
  curl -s https://repositories.intel.com/graphics/intel-graphics.key | apt-key add - && \
  echo 'deb [arch=amd64] https://repositories.intel.com/graphics/ubuntu focal main' > /etc/apt/sources.list.d/intel-graphics.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    at \
    intel-media-va-driver-non-free \
    jellyfin-server \
    jellyfin-web \
    jellyfin-ffmpeg \
    libfontconfig1 \
    libfreetype6 \
    libssl1.1 \
    libicu-dev \
    mesa-va-drivers && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY root/ / 

# ports and volumes
EXPOSE 8096 8920
VOLUME /config

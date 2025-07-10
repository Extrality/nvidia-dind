FROM docker.io/nvidia/cuda:12.9.1-runtime-ubuntu24.04

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y \
        apt-utils \
        ca-certificates \
        openssh-client \
        curl \
        iptables \
        gnupg

# NVIDIA Container Toolkit & Docker
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && \
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
        | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
        | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list && \
    apt-get update && \
    apt-get install -y nvidia-container-toolkit docker.io

# missing dockremap user

ENV DOCKER_TLS_CERTDIR=/certs
RUN mkdir /certs /certs/client && chmod 1777 /certs /certs/client

# https://github.com/docker-library/docker
ADD https://raw.githubusercontent.com/docker-library/docker/master/modprobe.sh /usr/local/bin/modprobe
ADD https://raw.githubusercontent.com/docker-library/docker/master/dockerd-entrypoint.sh /usr/local/bin/
ADD https://raw.githubusercontent.com/docker-library/docker/master/docker-entrypoint.sh /usr/local/bin/
ADD https://raw.githubusercontent.com/moby/moby/master/hack/dind /usr/local/bin/dind

RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh /usr/local/bin/docker-entrypoint.sh /usr/local/bin/dind

VOLUME /var/lib/docker
EXPOSE 2375 2376

ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD []

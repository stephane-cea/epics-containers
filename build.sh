#!/bin/sh

set -euxo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

# docker login

# rockylinux EPICS base containers
docker buildx build --platform=linux/amd64,linux/arm64 -t stephanecea/epics:rockylinux-8-epics-3.14.12.8 --push ./epics/rockylinux-8-epics-3.14.12.8
docker buildx build --platform=linux/amd64,linux/arm64 -t stephanecea/epics:rockylinux-8-epics-3.15.9 --push ./epics/rockylinux-8-epics-3.15.9
docker buildx build --platform=linux/amd64,linux/arm64 -t stephanecea/epics:rockylinux-8-epics-7.0.6.1 --push ./epics/rockylinux-8-epics-7.0.6.1

# centos EPICS base containers
docker buildx build --platform=linux/amd64,linux/arm64 -t stephanecea/epics:centos-7-epics-3.14.12.8 --push ./epics/centos-7-epics-3.14.12.8
docker buildx build --platform=linux/amd64,linux/arm64 -t stephanecea/epics:centos-7-epics-3.15.9 --push ./epics/centos-7-epics-3.15.9
docker buildx build --platform=linux/amd64,linux/arm64 -t stephanecea/epics:centos-7-epics-7.0.6.1 --push ./epics/centos-7-epics-7.0.6.1

# EPICS synapps containers
#docker buildx build --platform=linux/amd64,linux/arm64 -t stephanecea/epics:rockylinux-8-epics-3.14.12.8-synapps-6.2.1 --push ./epics/rockylinux-8-epics-3.14.12.8-synapps-6.2.1 # TODO : FIXME
docker buildx build --platform=linux/amd64,linux/arm64 -t stephanecea/epics:rockylinux-8-epics-3.15.9-synapps-6.2.1 --push ./epics/rockylinux-8-epics-3.15.9-synapps-6.2.1
docker buildx build --platform=linux/amd64,linux/arm64 -t stephanecea/epics:rockylinux-8-epics-7.0.6.1-synapps-6.2.1 --push ./epics/rockylinux-8-epics-7.0.6.1-synapps-6.2.1

# EPICS examples containers
docker buildx build --platform=linux/amd64,linux/arm64 -t stephanecea/epics:rockylinux-8-epics-7.0.6.1-example-top --push ./epics/rockylinux-8-epics-7.0.6.1-example-top


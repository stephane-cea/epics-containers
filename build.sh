#!/bin/sh

# docker login

# EPICS base containers
docker build -t stephanecea/epics:rockylinux-8-epics-3.14.12.8 ./epics/rockylinux-8-epics-3.14.12.8 && docker push stephanecea/epics:rockylinux-8-epics-3.14.12.8 || exit 1
docker build -t stephanecea/epics:rockylinux-8-epics-3.15.9 ./epics/rockylinux-8-epics-3.15.9 && docker push stephanecea/epics:rockylinux-8-epics-3.15.9 || exit 2
docker build -t stephanecea/epics:rockylinux-8-epics-7.0.6.1 ./epics/rockylinux-8-epics-7.0.6.1 && docker push stephanecea/epics:rockylinux-8-epics-7.0.6.1 || exit 3

# EPICS synapps containers
#docker build -t stephanecea/epics:rockylinux-8-epics-3.14.12.8-synapps-6.2.1 ./epics/rockylinux-8-epics-3.14.12.8-synapps-6.2.1 && docker push stephanecea/epics:rockylinux-8-epics-3.14.12.8-synapps-6.2.1 || exit 4 # TODO : FIXME
docker build -t stephanecea/epics:rockylinux-8-epics-3.15.9-synapps-6.2.1 ./epics/rockylinux-8-epics-3.15.9-synapps-6.2.1 && docker push stephanecea/epics:rockylinux-8-epics-3.15.9-synapps-6.2.1 || exit 5
docker build -t stephanecea/epics:rockylinux-8-epics-7.0.6.1-synapps-6.2.1 ./epics/rockylinux-8-epics-7.0.6.1-synapps-6.2.1 && docker push stephanecea/epics:rockylinux-8-epics-7.0.6.1-synapps-6.2.1 || exit 6

# EPICS examples containers
docker build -t stephanecea/epics:rockylinux-8-epics-7.0.6.1-example-top ./epics/rockylinux-8-epics-7.0.6.1-example-top && docker push stephanecea/epics:rockylinux-8-epics-7.0.6.1-example-top || exit 7

FROM rockylinux:8

######################
# install dependencies
#
#RUN dnf update -y --refresh
RUN dnf install -y dnf-plugins-core epel-release
RUN dnf config-manager --set-enabled powertools
RUN dnf group install -y "Development Tools"
RUN dnf install -y wget git perl
RUN dnf install -y readline-devel # EPICS base dependency
RUN dnf install -y re2c # SEQ dependency
RUN dnf install -y rpcsvc-proto-devel rpcgen libtirpc-devel # Asyn dependencies
RUN dnf install -y xorg-x11-proto-devel libX11-devel libXext-devel # Area Detector dependencies
RUN dnf install -y libusb-devel

#####################################
# prepare epics installation location
#
RUN groupadd epics
RUN mkdir /opt/epics
RUN chown root:epics /opt/epics && chmod 775 /opt/epics
RUN chmod g+s /opt/epics

###############################
# install EPICS base R3.14.12.8
#
WORKDIR /opt/epics
RUN git clone --recursive -b 3.14 https://git.launchpad.net/epics-base
WORKDIR /opt/epics/epics-base
RUN git checkout R3.14.12.8
RUN git submodule update --recursive
WORKDIR /opt/epics
RUN mv epics-base base-3.14.12.8-gcc
RUN ln -s base-3.14.12.8-gcc base
WORKDIR /opt/epics/base
RUN make clean && make

#################################
# set EPICS environment variables
#
RUN echo '' >> /etc/bashrc
RUN echo '# EPICS base' >> /etc/bashrc
RUN echo 'export EPICS_BASE=/opt/epics/base' >> /etc/bashrc
RUN echo 'export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)' >> /etc/bashrc
RUN echo 'export PATH=${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}' >> /etc/bashrc
RUN echo 'export LD_LIBRARY_PATH=${EPICS_BASE}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}' >> /etc/bashrc
RUN echo '#' >> /etc/bashrc
RUN echo '# EPICS support' >> /etc/bashrc
RUN echo 'export EPICS_SUPPORT=/opt/epics/synApps/support' >> /etc/bashrc
RUN echo 'export PATH=${EPICS_SUPPORT}/bin/${EPICS_HOST_ARCH}:${PATH}' >> /etc/bashrc
RUN echo 'export LD_LIBRARY_PATH=${EPICS_SUPPORT}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}' >> /etc/bashrc

ENV EPICS_BASE="/opt/epics/base"
ENV EPICS_HOST_ARCH="linux-x86_64"
ENV PATH="${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}"
ENV LD_LIBRARY_PATH="${EPICS_BASE}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}"

ENV EPICS_SUPPORT="/opt/epics/synApps/support"
ENV PATH="${EPICS_SUPPORT}/bin/${EPICS_HOST_ARCH}:${PATH}"
ENV LD_LIBRARY_PATH="${EPICS_SUPPORT}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}"

WORKDIR /opt/epics

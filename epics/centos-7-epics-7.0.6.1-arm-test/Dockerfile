FROM centos:centos7

######################
# install dependencies
#
RUN yum install -y epel-release \
 && yum group install -y "Development Tools" \
 && yum install -y wget \
 && yum install -y readline-devel \
 && yum install -y re2c \
 && yum install -y xorg-x11-proto-devel libX11-devel libXext-devel libusb-devel
#&& yum install -y rpcsvc-proto-devel rpcgen libtirpc-devel # Asyn dependencies

#####################################
# prepare epics installation location
#
RUN groupadd epics \
 && mkdir /opt/epics \
 && chown root:epics /opt/epics && chmod 775 /opt/epics \
 && chmod g+s /opt/epics

#############################
# install EPICS base R7.0.6.1
#
WORKDIR /opt/epics
RUN git clone --recursive -b 7.0 https://git.launchpad.net/epics-base
WORKDIR /opt/epics/epics-base
RUN git checkout R7.0.6.1
RUN git submodule update --recursive
WORKDIR /opt/epics
RUN mv epics-base base-7.0.6.1-gcc
RUN ln -s base-7.0.6.1-gcc base
WORKDIR /opt/epics/base
RUN make clean && make
#
##################################
## set EPICS environment variables
##
#RUN echo '' >> /etc/bashrc
#RUN echo '# EPICS base' >> /etc/bashrc
#RUN echo 'export EPICS_BASE=/opt/epics/base' >> /etc/bashrc
#RUN echo 'export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)' >> /etc/bashrc
#RUN echo 'export PATH=${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}' >> /etc/bashrc
#RUN echo 'export LD_LIBRARY_PATH=${EPICS_BASE}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}' >> /etc/bashrc
#RUN echo '#' >> /etc/bashrc
#RUN echo '# EPICS support' >> /etc/bashrc
#RUN echo 'export EPICS_SUPPORT=/opt/epics/synApps/support' >> /etc/bashrc
#RUN echo 'export PATH=${EPICS_SUPPORT}/bin/${EPICS_HOST_ARCH}:${PATH}' >> /etc/bashrc
#RUN echo 'export LD_LIBRARY_PATH=${EPICS_SUPPORT}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}' >> /etc/bashrc
#
#ENV EPICS_BASE="/opt/epics/base"
#ENV EPICS_HOST_ARCH="linux-x86_64"
#ENV PATH="${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}"
#ENV LD_LIBRARY_PATH="${EPICS_BASE}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}"
#
#ENV EPICS_SUPPORT="/opt/epics/synApps/support"
#ENV PATH="${EPICS_SUPPORT}/bin/${EPICS_HOST_ARCH}:${PATH}"
#ENV LD_LIBRARY_PATH="${EPICS_SUPPORT}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}"
#
#WORKDIR /opt/epics

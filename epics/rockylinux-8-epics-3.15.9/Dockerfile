FROM rockylinux:8

LABEL maintainer="Stéphane Tzvetkov" \
      name="EPICS base 3.15.9 on RockyLinux 8"

######################
# install dependencies
#
RUN dnf install -y wget `# needed to retrieve the EPICS base` \
 && dnf install -y make perl gcc gcc-c++ `# EPICS base dependencies` \
 && dnf clean all && rm -rf /var/cache/dnf

#####################################
# prepare epics installation location
#
RUN groupadd epics \
 && mkdir /opt/epics \
 && chown root:epics /opt/epics && chmod 775 /opt/epics \
 && chmod g+s /opt/epics

############################
# install EPICS base R3.15.9
#
RUN cd /opt/epics \
 && wget https://epics-controls.org/download/base/base-3.15.9.tar.gz \
 && tar -zxvf base-3.15.9.tar.gz \
 && rm -f base-3.15.9.tar.gz \
 && ln -s base-3.15.9 base \
 && cd base \
 && make \
 && make clean

######################################
# set EPICS base environment variables
#
RUN echo '' >> /etc/bashrc \
 && echo '# EPICS base' >> /etc/bashrc \
 && echo 'export EPICS_BASE=/opt/epics/base' >> /etc/bashrc \
 && echo 'export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)' >> /etc/bashrc \
 && echo 'export PATH=${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}' >> /etc/bashrc \
 && echo 'export LD_LIBRARY_PATH=${EPICS_BASE}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}' >> /etc/bashrc

##########
# clean up
#
RUN rm -rf /var/log/* /tmp/* /var/tmp/*

WORKDIR /opt/epics

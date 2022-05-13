FROM centos:centos7

LABEL maintainer="Stéphane Tzvetkov" \
      name="EPICS base 3.15.9 on CentOS 7"

######################
# install dependencies
#
RUN yum install -y wget `# needed to retrieve the EPICS base` \
 && yum install -y make perl gcc gcc-c++ `# EPICS base dependencies` \
 && yum clean all && rm -rf /var/cache/dnf

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
 && wget --no-check-certificate https://epics-controls.org/download/base/base-3.15.9.tar.gz \
 && tar -zxvf base-3.15.9.tar.gz \
 && rm -f base-3.15.9.tar.gz \
 && ln -s base-3.15.9 base \
 && sed -i "36i \ \ \ \ \ \ \ \ return 'linux-aarch64'  if m/^aarch64-linux/;" /opt/epics/base/src/tools/EpicsHostArch.pl `# allow linux-aarch64 (for arm64 builds)`

######################################
# set EPICS base environment variables
#
RUN echo '' >> /etc/bashrc \
 && echo '# EPICS base' >> /etc/bashrc \
 && echo 'export EPICS_BASE=/opt/epics/base' >> /etc/bashrc \
 && echo 'export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)' >> /etc/bashrc \
 && echo 'export PATH=${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}' >> /etc/bashrc \
 && echo 'export LD_LIBRARY_PATH=${EPICS_BASE}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}' >> /etc/bashrc

##################
# build EPICS base
#
RUN source /etc/bashrc \
 && cd /opt/epics/base \
 && make \
 && make clean

##########
# clean up
#
RUN rm -rf /var/log/* /tmp/* /var/tmp/*

WORKDIR /opt/epics

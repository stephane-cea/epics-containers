FROM stephanecea/epics:rockylinux-8-epics-3.15.9

LABEL maintainer="Stéphane Tzvetkov" \
      name="EPICS base 3.15.9 on RockyLinux 8"

######################
# install dependencies
#
RUN dnf install -y dnf-plugins-core \
 && dnf config-manager --set-enabled powertools \
 && dnf install -y git `# assemble_synApps.sh dependency` \
 && dnf install -y re2c `# SEQ dependency` \
 && dnf install -y rpcsvc-proto-devel rpcgen libtirpc-devel `# Asyn dependencies` \
 && dnf install -y xorg-x11-proto-devel libX11-devel libXext-devel libusb-devel `# Area Detector dependencies` \
 && dnf clean all && rm -rf /var/cache/dnf

############################################################################
# get [synApps R6-2-1](https://github.com/EPICS-synApps/support/tree/R6-2-1)
#
WORKDIR /opt/epics
RUN source /etc/bashrc `# load EPICS base related environment variables` \
 && wget https://raw.githubusercontent.com/EPICS-synApps/support/R6-2-1/assemble_synApps.sh \
 && `#` \
 && `# set EPICS base location` \
 && sed -i 's/^EPICS_BASE=.*/EPICS_BASE=\/opt\/epics\/base/g' assemble_synApps.sh \
 && `#` \
 && `# use a more recent version release of [camac](https://github.com/epics-modules/camac)` \
 && `# see https://github.com/epics-modules/camac/commit/5dea4210bef24a12a85ad8cc3d0c85c7772c2584` \
 && sed -i 's/^CAMAC=R2-7-3/CAMAC=R2-7-4/g' assemble_synApps.sh \
 && `#` \
 && `# use a more recent version release of [sscan](https://github.com/epics-modules/sscan)` \
 && `# see https://github.com/epics-modules/sscan/issues/20` \
 && `# see https://github.com/epics-modules/sscan/commit/420274ca2e4331e92119bd0524d0bcd7ffdd9f93` \
 && sed -i 's/^SSCAN=R2-11-4/SSCAN=R2-11-5/g' assemble_synApps.sh \
 && `#` \
 && `# use a more recent version release of [caputrecorder](https://github.com/epics-modules/caputRecorder)` \
 && `# see https://github.com/epics-modules/caputRecorder/issues/4` \
 && `# see https://github.com/epics-modules/caputRecorder/pull/5` \
 && sed -i 's/^CAPUTRECORDER=R1-7-3/CAPUTRECORDER=R1-7-4/g' assemble_synApps.sh \
 && `#` \
 && bash ./assemble_synApps.sh \
 && mv synApps synApps-6.2.1 \
 && ln -s synApps-6.2.1 synApps

######################################
# set TIRPC=YES in synApps Asyn module
#
WORKDIR /opt/epics/synApps/support/asyn-R4-42
RUN sed -i 's/^# TIRPC=.*/TIRPC=YES/g' configure/CONFIG_SITE

################################################
# set WITH_PVA=NO in synApps areaDetector module
#
WORKDIR /opt/epics/synApps/support/areaDetector-R3-11
RUN sed -i 's/^WITH_PVA  = YES/WITH_PVA  = NO/g' configure/CONFIG_SITE.local \
 && sed -i 's/^WITH_QSRV = YES/WITH_QSRV = NO/g' configure/CONFIG_SITE.local

########################################################################
# fix [motor R7-2-2](https://github.com/epics-modules/motor/tree/R7-2-2)
# see https://epics.anl.gov/tech-talk/2021/msg01911.php
# see https://github.com/epics-modules/motor/commit/784e41927b942d38c31a766309668d6114861b9e
#
WORKDIR /opt/epics/synApps/support/motor-R7-2-2
COPY 784e419.patch .
RUN if ! $(grep -q "#include <shareLib.h>" motorApp/MotorSrc/motordrvCom.h); then git apply 784e419.patch; fi \
 && rm 784e419.patch

##############################################################################
# build [synApps R6-2-1](https://github.com/EPICS-synApps/support/tree/R6-2-1)
#
WORKDIR /opt/epics/synApps/support
RUN source /etc/bashrc `# load EPICS base related environment variables` \
 && make release \
 && make rebuild \
 && make clean

#########################################
# set EPICS support environment variables
#
RUN echo '#' >> /etc/bashrc \
 && echo '# EPICS support' >> /etc/bashrc \
 && echo 'export EPICS_SUPPORT=/opt/epics/synApps/support' >> /etc/bashrc \
 && echo 'export PATH=${EPICS_SUPPORT}/bin/${EPICS_HOST_ARCH}:${PATH}' >> /etc/bashrc \
 && echo 'export LD_LIBRARY_PATH=${EPICS_SUPPORT}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}' >> /etc/bashrc

##########
# clean up
#
RUN rm -rf /var/log/* /tmp/* /var/tmp/*

WORKDIR /opt/epics

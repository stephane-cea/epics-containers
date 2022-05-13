FROM stephanecea/epics:rockylinux-8-epics-3.14.12.8

RUN yum install -y re2c # SEQ dependency
#RUN yum install -y rpcsvc-proto-devel rpcgen libtirpc-devel # Asyn dependencies
RUN yum install -y xorg-x11-proto-devel libX11-devel libXext-devel libusb-devel # Area Detector dependencies


######################################################################################
# get [MSI R1-7](https://epics.anl.gov/extensions/msi/index.php) as an EPICS extension
# (dependency for synApps' iocStats module with EPICS base 3.14)
#
# install EPICS extensions Top (04/09/2012)
WORKDIR /opt/epics
RUN wget 'https://epics.anl.gov/download/extensions/extensionsTop_20120904.tar.gz'
RUN tar -zxvf extensionsTop_20120904.tar.gz
RUN rm -rf extensionsTop_20120904.tar.gz
#
# install MSI R1-7
WORKDIR /opt/epics/extensions/src
RUN wget 'https://epics.anl.gov/download/extensions/msi1-7.tar.gz'
RUN tar -zxvf msi1-7.tar.gz
RUN rm -rf msi1-7.tar.gz
RUN sed -i 's/^EXTENSION_MSI = msi/EXTENSION_MSI = msi1-7/g' Makefile
WORKDIR /opt/epics/extensions
RUN make clean && make
#
# set EPICS extensions environment variables
RUN echo '#' >> /etc/bashrc
RUN echo '# EPICS extensions' >> /etc/bashrc
RUN echo 'export EPICS_EXTENSIONS=/opt/epics/extensions' >> /etc/bashrc
RUN echo 'export PATH=${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}:${PATH}' >> /etc/bashrc
#RUN echo 'export LD_LIBRARY_PATH=${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}' >> /etc/bashrc

ENV EPICS_HOST_ARCH="linux-x86_64"
ENV EPICS_EXTENSIONS="/opt/epics/extensions"
ENV PATH="PATH=${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}:${PATH}"
#ENV LD_LIBRARY_PATH="LD_LIBRARY_PATH=${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}"

############################################################################
# get [synApps R6-2-1](https://github.com/EPICS-synApps/support/tree/R6-2-1)
#
WORKDIR /opt/epics
RUN wget https://raw.githubusercontent.com/EPICS-synApps/support/R6-2-1/assemble_synApps.sh
#
# set EPICS base location
RUN sed -i 's/^EPICS_BASE=.*/EPICS_BASE=\/opt\/epics\/base/g' assemble_synApps.sh
#
# use a more recent version release of [camac](https://github.com/epics-modules/camac)
# see https://github.com/epics-modules/camac/commit/5dea4210bef24a12a85ad8cc3d0c85c7772c2584
RUN sed -i 's/^CAMAC=R2-7-3/CAMAC=R2-7-4/g' assemble_synApps.sh
#
# use a more recent version release of [sscan](https://github.com/epics-modules/sscan)
# see https://github.com/epics-modules/sscan/issues/20
# see https://github.com/epics-modules/sscan/commit/420274ca2e4331e92119bd0524d0bcd7ffdd9f93
RUN sed -i 's/^SSCAN=R2-11-4/SSCAN=R2-11-5/g' assemble_synApps.sh
#
# use a more recent version release of [caputrecorder](https://github.com/epics-modules/caputRecorder)
# see https://github.com/epics-modules/caputRecorder/issues/4
# see https://github.com/epics-modules/caputRecorder/pull/5
RUN sed -i 's/^CAPUTRECORDER=R1-7-3/CAPUTRECORDER=R1-7-4/g' assemble_synApps.sh
#
RUN bash ./assemble_synApps.sh
RUN mv synApps synApps-6.2.1
RUN ln -s synApps-6.2.1 synApps

######################################
# set TIRPC=YES in synApps Asyn module
#
WORKDIR /opt/epics/synApps/support/asyn-R4-42
RUN sed -i 's/^# TIRPC=.*/TIRPC=YES/g' configure/CONFIG_SITE

################################################
# set WITH_PVA=NO in synApps areaDetector module
#
WORKDIR /opt/epics/synApps/support/areaDetector-R3-11
RUN sed -i 's/^WITH_PVA  = YES/WITH_PVA  = NO/g' configure/CONFIG_SITE.local
RUN sed -i 's/^WITH_QSRV = YES/WITH_QSRV = NO/g' configure/CONFIG_SITE.local

########################################################################
# fix [motor R7-2-2](https://github.com/epics-modules/motor/tree/R7-2-2)
# see https://epics.anl.gov/tech-talk/2021/msg01911.php
# see https://github.com/epics-modules/motor/commit/784e41927b942d38c31a766309668d6114861b9e
#
WORKDIR /opt/epics/synApps/support/motor-R7-2-2
COPY 784e419.patch .
#RUN echo 'diff --git a/motorApp/MotorSrc/motordrvCom.h b/motorApp/MotorSrc/motordrvCom.h\n\
#index 98e736af..4f701ffa 100644\n\
#--- a/motorApp/MotorSrc/motordrvCom.h\n\
#+++ b/motorApp/MotorSrc/motordrvCom.h\n\
#@@ -45,6 +45,7 @@ USAGE...	This file contains definitions and structures that\n\
# #ifndef	INCmotordrvComh\n\
# #define	INCmotordrvComh 1\n\
# \n\
#+#include <shareLib.h>\n\
# #include <callback.h>\n\
# #include <epicsTypes.h>\n\
# #include <epicsEvent.h>' > 784e419.patch
RUN if ! $(grep -q "#include <shareLib.h>" motorApp/MotorSrc/motordrvCom.h); then git apply 784e419.patch; fi
RUN rm 784e419.patch

##############################################################################
# build [synApps R6-2-1](https://github.com/EPICS-synApps/support/tree/R6-2-1)
#
WORKDIR /opt/epics/synApps/support
RUN make release
RUN make clean && make rebuild

WORKDIR /opt/epics

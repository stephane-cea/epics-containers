FROM rockylinux

######################
# install dependencies
#
RUN dnf update -y --refresh
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

############################
# install EPICS base R3.15.9
#
WORKDIR /opt/epics
RUN git clone --recursive -b 3.15 https://git.launchpad.net/epics-base
WORKDIR /opt/epics/epics-base
RUN git checkout R3.15.9
RUN git submodule update --recursive
WORKDIR /opt/epics
RUN mv epics-base base-3.15.9-gcc
RUN ln -s base-3.15.9-gcc base
WORKDIR /opt/epics/base
RUN make clean && make

#################################
# set EPICS environment variables
#
RUN echo '# EPICS base\n\
export EPICS_BASE=/opt/epics/base\n\
export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)\n\
export PATH=${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}\n\
export LD_LIBRARY_PATH=${EPICS_BASE}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}\n\
\n\
# EPICS support\n\
export EPICS_SUPPORT=/opt/epics/synApps/support\n\
export PATH=${EPICS_SUPPORT}/bin/${EPICS_HOST_ARCH}:${PATH}\n\
export LD_LIBRARY_PATH=${EPICS_SUPPORT}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}' >> /etc/bashrc
RUN source /etc/bashrc

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


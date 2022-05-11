FROM stephanecea/epics:rockylinux-8-epics-7.0.6.1

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

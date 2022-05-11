FROM stephanecea/epics:rockylinux-8-epics-7.0.6.1

#############################
# create an EPICS example top
#
RUN mkdir /opt/epics/example-top
WORKDIR /opt/epics/example-top
ENV USER=epics
RUN makeBaseApp.pl -a linux-x86_64 -t example example
RUN makeBaseApp.pl -a linux-x86_64 -i -t example -p example example
RUN make
RUN chmod +x iocBoot/iocexample/st.cmd

WORKDIR /opt/epics

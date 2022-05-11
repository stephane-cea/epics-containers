# epics-containers

The goal of this project is to provide multiple EPICS docker containers for development and testing
(those can also be used for training).

All containers can be found here: <https://hub.docker.com/repository/docker/stephanecea/epics>.

## Related projects

- <https://github.com/pklaus/docker-epics-directory>
- <https://github.com/prjemian/epics-docker>

## How to use

> **⚠️ Prerequisite(s) ⚠️**: [docker](https://docs.docker.com/get-started/overview/)

* Explore and use an EPICS container in an interactive bash shell:
    ```console
    $ docker pull stephanecea/epics:rockylinux-8-epics-7.0.6.1-synapps-6.2.1
    $ docker run -it stephanecea/epics:rockylinux-8-epics-7.0.6.1-synapps-6.2.1 bash
    ```

* Create an EPICS top on your host computer and test it in an EPICS container, e.g. test the
  default EPICS example template top against EPICS base R7.0.1:
    ```console
    $ cd /path/to/example-top
    $ makeBaseApp.pl -a linux-x86_64 -t example example
    $ makeBaseApp.pl -a linux-x86_64 -i -t example -p example example
    $ make clean && make

    $ vi confiure/RELEASE
        > ...
      ~ > EPICS_BASE = /path/to/your/epics/base
        > ...

    $ chmod +x iocBoot/iocexample/st.cmd
    $ cd iocBoot/iocexample/st.cmd
    $ ./st.cmd
        epics> echo "check your things here"
        epics> exit

    $ docker pull stephanecea/epics:rockylinux-8-epics-7.0.6.1-synapps-6.2.1
    $ id # find your user ID and group ID in order to run your container with it
        > uid=1234(username) gid=1234(username) ...

    $ docker run -it --user 1000:1000 -v "/path/to/example-top:/opt/epics/example-top" stephanecea/epics:rockylinux-8-epics-7.0.6.1 bash

        container$ cd /opt/epics/example-top
        container$ vi confiure/RELEASE
            > ...
          ~ > EPICS_BASE = /opt/epics/base
            > ...
        conainer$ make clean && make

        container$ cd iocBoot/iocexample/st.cmd
        container$ ./st.cmd
            epics> echo "check your things here"
            epics> exit

        container$ exit

    $ docker run -it --user 1000:1000 -v "/path/to/example-top:/opt/epics/example-top" stephanecea/epics:rockylinux-8-epics-7.0.6.1 ./opt/epics/example-top/run_your_ci_test_script.sh
    ```

* Run an example top from, e.g. the example top build against EPICS R7.0.6.1:
    ```console
    $ docker pull stephanecea/epics:rockylinux-8-epics-7.0.6.1-example-top
    $ docker run -it --user 1000:1000 stephanecea/epics:rockylinux-8-epics-7.0.6.1-example-top bash -c "cd /opt/epics/example-top/iocBoot/iocexample && ./st.cmd"
    ```

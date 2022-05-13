# epics-containers

The goal of this project is to provide multiple EPICS docker containers for development and testing
(those can also be used for training).

All containers can be found here: <https://hub.docker.com/repository/docker/stephanecea/epics>.

## Related projects

- <https://epics-containers.github.io/main/index.html>
- <https://github.com/pklaus/docker-epics-directory>
- <https://github.com/prjemian/epics-docker>

## Multi-Arch prerequisites

> **⚠️ Prerequisite(s) ⚠️**: if you intend to build and/or run linux/arm64 or linux/ppc64le on your
> amd64 host, then you will need to install and configure `binfmt` and `qemu` like describe bellow.
> If not, then you can skip this section.

E.g. on Ubuntu, install `qemu` `binfmt-support` and `qemu-user-static`:
```console
$ sudo apt install qemu binfmt-support qemu-user-static
```

E.g. on Arch Linux, install `qemu-headless` `binfmt-qemu-static` and `qemu-user-static-bin`:
```console
$ sudo pacman -S qemu-headless

$ git clone https://aur.archlinux.org/binfmt-qemu-static.git
$ cd binfmt-qemu-static
$ makepkg -si
$ cd ..

$ git clone https://aur.archlinux.org/packages/qemu-user-static-bin
$ cd qemu-user-static-bin
$ makepkg -si
$ cd ..
```

Then register additional architectures and test the arm64 one:
```console
$ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
$ docker run --rm -t arm64v8/ubuntu uname -m # Testing the emulation environment
```

## How to use

> **⚠️ Prerequisite(s) ⚠️**: [docker](https://docs.docker.com/get-started/overview/)

- Explore and use an EPICS container in an interactive bash shell:
    ```console
    $ docker pull stephanecea/epics:rockylinux-8-epics-7.0.6.1-synapps-6.2.1
    $ docker run -it stephanecea/epics:rockylinux-8-epics-7.0.6.1-synapps-6.2.1 bash
    ```

- Create an EPICS top on your host computer and test it in an EPICS container, e.g. test the
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

- Run an example top from, e.g. the example top build against EPICS R7.0.6.1:
    ```console
    $ docker pull stephanecea/epics:rockylinux-8-epics-7.0.6.1-example-top
    $ docker run -it --user 1000:1000 stephanecea/epics:rockylinux-8-epics-7.0.6.1-example-top bash -c "cd /opt/epics/example-top/iocBoot/iocexample && ./st.cmd"
    ```

- Run an arm64 container on a amd64 host:
    - **⚠️ Prerequisite(s) ⚠️**: [Multi-Arch prerequisites](#multi-arch-prerequisites)
    - E.g. pull the `epics:centos-7-epics-7.0.6.1-arm-test` arm64 container and run it:
        ```console
        $ docker pull --platform=linux/arm64 stephanecea/epics:centos-7-epics-7.0.6.1-arm-test
        $ docker run -it --platform=linux/arm64 stephanecea/epics:centos-7-epics-7.0.6.1-arm-test bash -c "uname -m"
        ```

## How to build

> **⚠️ Prerequisite(s) ⚠️**: [Multi-Arch prerequisites](#multi-arch-prerequisites)

- First, create a builder in order to access new multi-architecture features:
    ```console
    $ docker buildx ls
    $ docker buildx create --name mybuilder
    $ docker buildx use mybuilder
    $ docker buildx inspect --bootstrap
    ```

- Now build the image you want, e.g. `epics:centos-7-epics-7.0.6.1` for both `linux/amd64` and
  `linux/arm64`:
    ```console
    $ docker buildx build --platform=linux/amd64,linux/arm64 -t stephanecea/epics:centos-7-epics-7.0.6.1 epics/centos-7-epics-7.0.6.1
    ```

- Useful references:
    - <https://www.reddit.com/r/docker/comments/c75uhq/how_to_run_arm64_containers_from_amd64_hosts_and/>
    - <https://matchboxdorry.gitbooks.io/matchboxblog/content/blogs/build_and_run_arm_images.html>
    - <https://www.stereolabs.com/docs/docker/building-arm-container-on-x86/>
    - <https://docs.docker.com/desktop/multi-arch/>

# Discord
FnOScommunity is now on Discord!

[![Discord](https://img.shields.io/discord/732558169863225384?color=7289DA&label=Discord&logo=Discord&logoColor=white&style=for-the-badge)](https://discord.gg/nnN9fgE7EF)

# fpksrc
fpksrc is a cross compilation framework intended to compile and package software for Synology NAS devices. Packages are made available via the [FnOScommunity repository].


# DSM 7
DSM 7 was released on June 29 2021 as Version 7.0.41890.

* The main issue we had with our reposity is fixed in [fpkrepo](https://github.com/FnOScommunity/fpkrepo/pull/112) and online since February 2024
  - before the repository deliverd DSM 6 packages for Systems with DSM 7, when no DSM 7 package was available
  - this gave errors like "invalid file format" (or "package requires root privileges")
  - you still get this error when manually installing a DSM 6 package on DSM 7
* You find the status of the former packages in the issue [#4524] **Meta: DSM7 package status**
* New packages support DSM 7 from initial package version (and some require at least DSM 7).
* **ATTENTION**: As reported, package configuration settings may be lost following the upgrade to DSM 7 and the execution of a Package repair. Make sure to backup your settings and configuration for your FnOScommunity packages before installation of DSM 7 to facilitate restoration if needed.


## Contributing
Before opening a new issue, check the [FAQ] and search open issues.
If you can't find an answer, or if you want to open a package request, read [CONTRIBUTING] to make sure you include all the information needed for contributors to handle your request.


## Setup Development Environment
### Docker
*The Docker development environment supports Linux and macOS systems, but not Windows due to limitations of the underlying file system.*

1. [Fork and clone] fpksrc: `git clone https://github.com/YOUR-USERNAME/fpksrc`
2. Install Docker on your host OS (see [Docker installation], or use a `wget`-based alternative for linux [Install Docker with wget]).
3. Download the fpksrc Docker container: `docker pull ghcr.io/fnoscommunity/fpksrc`
4. Run the container with the repository mounted into the `/fpksrc` directory with the appropriate command for your host Operating System:

```bash
cd fpksrc # Go to the cloned repository's root folder.

# If running on Linux:
docker run -it --platform=linux/amd64 -v $(pwd):/fpksrc -w /fpksrc ghcr.io/fnoscommunity/fpksrc /bin/bash

# If running on macOS:
docker run -it --platform=linux/amd64 -v $(pwd):/fpksrc -w /fpksrc -e TAR_CMD="fakeroot tar" ghcr.io/fnoscommunity/fpksrc /bin/bash
```
5. From there, follow the instructions in the [Developers HOW TO].



### Virtual machine
A virtual machine based on an 64-bit version of Debian 13 stable OS is recommended. Non-x86 architectures are not supported.

Install the requirements (in sync with `Dockerfile`):
```bash
sudo dpkg --add-architecture i386 && sudo apt-get update
sudo apt update
sudo apt install --no-install-recommends -y \
                 autoconf-archive autogen automake autopoint \
                 bash bash-completion bc bison build-essential \
                 check cmake curl cython3 debootstrap ed expect \
                 fakeroot flex gh g++-multilib gawk gettext gfortran \
                 git gobject-introspection gperf imagemagick intltool \
                 jq libbz2-dev libc6-i386 libcppunit-dev libelf-dev \
                 libffi-dev libgc-dev libgmp3-dev libicu76 libltdl-dev \
                 libmount-dev libncurses-dev libpcre2-dev libssl-dev \
                 libtool libtool-bin libunistring-dev lzip man-db manpages-dev \
                 moreutils nasm p7zip patchelf php pkg-config plocate \
                 rename ripgrep rsync ruby-mustache scons subversion \
                 sudo swig texinfo time tree unzip xmlto yasm \
                 zip zlib1g-dev
```
Install Python based dependencies (also in sync with `Dockerfile`):
```
sudo apt install --no-install-recommends -y \
                 httpie mercurial meson ninja-build \
                 python3 python3-mako python3-pip python3-setuptools \
                 python3-virtualenv python3-yaml
```
From there, follow the instructions in the [Developers HOW TO].


### LXC
A container based on 64-bit version of Debian 13 stable OS is recommended. Non-x86 architectures are not supported.  The following assumes your LXD/LXC environment is already initiated (e.g. `lxc init`) and you have minimal LXD/LXC basic knowledge :

1. Create a new container (will use x86_64/amd64 arch by default): `lxc launch images:debian/13 fpksrc`

2. Enable i386 arch: `lxc exec fpksrc -- /usr/bin/dpkg --add-architecture i386`

3. Update apt channels: `lxc exec fpksrc -- /usr/bin/apt update`

4. Install all default required packages:
```bash
lxc exec fpksrc -- /usr/bin/apt install --no-install-recommends -y \
                 autoconf-archive autogen automake autopoint \
                 bash bash-completion bc bison build-essential \
                 check cmake curl cython3 debootstrap ed expect \
                 fakeroot flex gh g++-multilib gawk gettext gfortran \
                 git gobject-introspection gperf imagemagick intltool \
                 jq libbz2-dev libc6-i386 libcppunit-dev libelf-dev \
                 libffi-dev libgc-dev libgmp3-dev libicu76 libltdl-dev \
                 libmount-dev libncurses-dev libpcre2-dev libssl-dev \
                 libtool libtool-bin libunistring-dev lzip man-db manpages-dev \
                 moreutils nasm p7zip patchelf php pkg-config plocate \
                 rename ripgrep rsync ruby-mustache scons subversion \
                 sudo swig texinfo time tree unzip xmlto yasm \
                 zip zlib1g-dev
```

5. Install Python based dependencies:
```bash
lxc exec fpksrc -- /usr/bin/apt install --no-install-recommends -y \
                 httpie mercurial meson ninja-build \
                 python3 python3-mako python3-pip python3-setuptools \
                 python3-virtualenv python3-yaml
```

#### LXC: `fpksrc` user

6. By default it is assumed that you will be running as `fpksrc` user into the LXC container.  Such user needs to be created into the default container image:
```bash
lxc exec fpksrc -- /usr/sbin/adduser --uid 1001 fpksrc
```

7. Setup a default shell environment:
```bash
lxc exec fpksrc --user 1001 -- cp /etc/skel/.profile /etc/skel/.bashrc ~fpksrc/.
```

From there you can connect to your container as `fpksrc` and follow the instructions in the [Developers HOW TO].
```bash
lxc exec fpksrc -- su --login fpksrc
fpksrc@fpksrc:~$
```

#### (OPTIONAL) LXC: Shared `fpksrc` user
You can create a shared user between your Debian/Ubuntu host and the LXC Debian container which simplifies greatly file management between the two.  The following assumes you already created a user `fpksrc` with uid 1001 in your Debian/Ubuntu host environment and that you whish to share its `/home` userspace.

8. Create a mapping rule between the hosts and the LXC image:
```bash
lxc config set fpksrc raw.idmap "both 1001 1001"
lxc restart fpksrc
Remapping container filesystem
```

9. Add `/home/fpksrc` from the host to the LXC container:
```bash
lxc config device add fpksrc home disk path=/home/fpksrc source=/home/fpksrc
Device home added to fpksrc
```

10. Connect as `fpksrc` user:
```bash
lxc exec fpksrc -- su --login fpksrc
fpksrc@fpksrc:~$
```

#### LXC: Proxy (OPTIONAL)
The following assume you have a running proxy on your LAN setup at IP 192.168.1.1 listening on port 3128 that will allow caching files.

11. Enforce using a proxy:
```bash
lxc config set fpksrc environment.http_proxy http://192.168.1.1:3128
lxc config set fpksrc environment.https_proxy http://192.168.1.1:3128
```

12. Enforce using a proxy with `wget` in the fpksrc container user account:
```bash
lxc exec fpksrc --user $(id -u fpksrc) -- bash -c "cat << EOF > ~fpksrc/.wgetrc
use_proxy = on
http_proxy = http://192.168.1.1:3128/
https_proxy = http://192.168.1.1:3128/
ftp_proxy = http://192.168.1.1:3128/
EOF"
```


## Usage
Once you have a development environment set up, you can start building packages, create new ones, or improve upon existing packages while making your changes available to other people.
See the [Developers HOW TO] for information on how to use fpksrc.


## License
When not explicitly set, files are placed under a [3 clause BSD license]

[3 clause BSD license]: http://www.opensource.org/licenses/BSD-3-Clause
[#4524]: https://github.com/fnoscommunity/fpksrc/issues/4524
[bug tracker]: https://github.com/fnoscommunity/fpksrc/issues
[CONTRIBUTING]: https://github.com/fnoscommunity/fpksrc/blob/master/CONTRIBUTING.md
[Fork and clone]: https://docs.github.com/en/github/getting-started-with-github/fork-a-repo
[Developers HOW TO]: https://github.com/fnoscommunity/fpksrc/wiki/Developers-HOW-TO
[Docker installation]: https://docs.docker.com/engine/installation
[FAQ]: https://github.com/fnoscommunity/fpksrc/wiki/Frequently-Asked-Questions
[Install Docker with wget]: https://docs.docker.com/linux/step_one
[FnOScommunity repository]: http://www.FnOScommunity.com

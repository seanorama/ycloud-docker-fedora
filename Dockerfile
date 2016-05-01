FROM docker.io/fedora

ENV container docker

ENV PYTHON_VERSION 2.7.8

RUN dnf -y update

#RUN dnf -y install systemd && \
#(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
#rm -f /lib/systemd/system/multi-user.target.wants/*;\
#rm -f /etc/systemd/system/*.wants/*;\
#rm -f /lib/systemd/system/local-fs.target.wants/*; \
#rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
#rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
#rm -f /lib/systemd/system/basic.target.wants/*;\
#rm -f /lib/systemd/system/anaconda.target.wants/*;

## Workaround for Slider Python 2.7.9 bug
RUN dnf -y groupinstall "Development tools"
RUN dnf -y install file tar zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
RUN set -ex \
	&& curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tgz" -o python.tgz \
	&& mkdir -p /usr/local/src/python \
	&& tar -xzC /usr/local/src/python --strip-components=1 -f python.tgz \
	&& rm -f python.tgz \
	\
	&& cd /usr/local/src/python \
	&& ./configure --enable-unicode=ucs4 --prefix=/opt/python \
	&& make -j$(nproc) \
	&& make install \
	&& rm -rf /usr/local/src/python ~/.cache

## Clean yum space
RUN dnf clean all

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

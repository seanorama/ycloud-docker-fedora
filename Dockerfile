FROM docker.io/fedora

## YCloud Slider requirements
RUN dnf -y update \
	&& dnf -y install procps iproute hostname \
	&& dnf clean all

## YCloud Slider bug requiring Python <2.7.9
ENV PYTHON_VERSION 2.7.8
RUN dnf -y groupinstall "Development tools" \
	&& dnf -y install file tar zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel \
	\
	&& curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tgz" -o python.tgz \
	&& mkdir -p /usr/local/src/python \
	&& tar -xzC /usr/local/src/python --strip-components=1 -f python.tgz \
	&& rm -f python.tgz \
	\
	&& cd /usr/local/src/python \
	&& ./configure --enable-unicode=ucs4 --prefix=/opt/python \
	&& make -j$(nproc) \
	&& make install \
	&& rm -rf /usr/local/src/python ~/.cache \
	\
	&& dnf -y remove zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel \
	&& dnf -y groupremove "Development tools" \
	&& dnf -y autoremove \
	&& dnf clean all


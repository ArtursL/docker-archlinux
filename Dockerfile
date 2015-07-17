#FROM base/archlinux
FROM scratch
MAINTAINER "Arturs Liepins" <arturs@liepins.me>

ADD busybox /tmp/wget
ADD busybox /tmp/sh
ADD tar /tmp/tar
ADD gzip /tmp/gzip

#RUN [ "/tmp/wget", "http://mirrors.kernel.org/archlinux/iso/2015.06.01/archlinux-bootstrap-2015.06.01-x86_64.tar.gz" ]
#RUN [ "/tmp/gzip", "-d", "archlinux-bootstrap-2015.06.01-x86_64.tar.gz"]
#RUN [ "/tmp/tar", "--preserve-permissions", "--skip-old-files", "--strip-components=1", "-xf", "archlinux-bootstrap-2015.06.01-x86_64.tar" ]
ENV SHELL /tmp/sh
RUN  [ "/tmp/sh", "-c", "/tmp/wget http://mirrors.kernel.org/archlinux/iso/2015.06.01/archlinux-bootstrap-2015.06.01-x86_64.tar.gz -O - |   /tmp/gzip -d |   /tmp/tar --preserve-permissions --skip-old-files --strip-components=1 -xf -"]
ENV SHELL /bin/bash

#Clean up
RUN rm -v /tmp/*
RUN rm archlinux-bootstrap-2015.06.01-x86_64.tar
RUN rm README
RUN echo "Server = http://mirror.rackspace.com/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist

#This env variable is checked by systemd
ENV container docker

RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman -Syy
RUN pacman -S --noconfirm --needed --noprogressbar pacman
RUN pacman-db-upgrade
RUN pacman -Syu --noconfirm --needed --noprogressbar
RUN yes | pacman -Scc

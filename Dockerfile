FROM centos:7

RUN yum install -y epel-release dnf \
        && dnf install -y tigervnc-server openbox obconf-qt \
            lxqt-about lxqt-common lxqt-config lxqt-globalkeys lxqt-notificationd \
            lxqt-openssh-askpass lxqt-panel lxqt-policykit lxqt-qtplugin lxqt-runner \
            lxqt-session pcmanfm-qt dejavu-sans-mono-fonts \
            xterm nano htop expect sudo \
        && yum clean all && dnf clean all \
        && rm -rf /var/cache/yum/* && rm -rf /var/cache/dnf/*

RUN yum -y groups install "GNOME Desktop"

ENV HOME=/home/alex

RUN /bin/dbus-uuidgen --ensure && \
        useradd alex && \
        echo "secret" | passwd --stdin root && \
        echo "secret" | passwd --stdin alex

COPY ./startup.sh ${HOME}
RUN mkdir -p ${HOME}/.vnc \
        && \
        echo '#!/bin/sh' > ${HOME}/.vnc/xstartup && \
        echo 'exec startlxqt' >> ${HOME}/.vnc/xstartup && \
        chmod 775 ${HOME}/.vnc/xstartup 

RUN yum install -y mc

RUN chown alex:alex -R ${HOME}

WORKDIR ${HOME}
USER alex
ENTRYPOINT ["expect", "./startup.sh"]
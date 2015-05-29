FROM cloudpack/centos

RUN yum -y update
RUN yum -y install initscripts openssh-server openssh-clients bash-completion tar
RUN yum -y clean all

RUN sshd-keygen
RUN sed -ri 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

RUN mkdir /var/log/openssh
VOLUME /var/log/openssh

CMD mkdir /root/.ssh && \
    chmod 600 /root/.ssh && \
    curl -s -o /root/.ssh/authorized_keys http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key && \
    chmod 600 /root/.ssh/authorized_keys && \
    /usr/sbin/sshd -4 -D -E /var/log/openssh/openssh.log
EXPOSE 22

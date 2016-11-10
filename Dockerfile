FROM daocloud.io/centos:7.2.1511

###### EPEL repository
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

###### install basic tools
RUN yum install -y sudo

###### add user gauss
ENV USER_NAME gauss
ENV USER_HOME /home/$USER_NAME
RUN useradd $USER_NAME -m && \
	( echo 'gauss    ALL=(ALL)       NOPASSWD:ALL' > /etc/sudoers.d/$USER_NAME ) && \
	sed 's/^Defaults \{1,\}requiretty'//g -i /etc/sudoers

ADD lang.sh /etc/profile.d/
USER $USER_NAME

###### enable .bashrc.d
RUN echo 'for f in $(ls ~/.bashrc.d/); do source ~/.bashrc.d/$f; done' >> $USER_HOME/.bashrc && \
	mkdir -p $USER_HOME/.bashrc.d

CMD bash

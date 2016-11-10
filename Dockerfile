FROM daocloud.io/centos:7.2.1511

###### EPEL repository
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

###### install basic tools
RUN yum -y install sudo

###### add user gauss
ENV USER gauss
ENV USER_HOME /home/$USER
RUN ( printf '$USER\n$USER\n' | passwd ) && \
	useradd $USER && \
	( printf '$USER\n$USER\n' | passwd $USER ) && \
	( echo '$USER    ALL=(ALL)       NOPASSWD:ALL' > /etc/sudoers.d/$USER ) && \
	sed 's/^Defaults \{1,\}requiretty'//g -i /etc/sudoers && \
	mkdir -p $USER_HOME/bin && \
	chown $USER:$USER $USER_HOME/bin

ADD lang.sh /etc/profile.d/
USER $USER

###### enable .bashrc.d
RUN echo 'for f in $(ls ~/.bashrc.d/); do source ~/.bashrc.d/$f; done' >> $USER_HOME/.bashrc && \
	mkdir -p $USER_HOME/.bashrc.d

CMD bash

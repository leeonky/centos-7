FROM daocloud.io/centos:7.2.1511

###### EPEL repository
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

###### install basic tools
RUN yum -y install sudo

###### add user devuser
ENV DEV_HOME /home/devuser
RUN ( printf 'devuser\ndevuser\n' | passwd ) && \
	useradd devuser && \
	( printf 'devuser\ndevuser\n' | passwd devuser ) && \
	( echo 'devuser    ALL=(ALL)       NOPASSWD:ALL' > /etc/sudoers.d/devuser ) && \
	sed 's/^Defaults \{1,\}requiretty'//g -i /etc/sudoers && \
	mkdir -p $DEV_HOME/bin && \
	chown devuser:devuser $DEV_HOME/bin

ADD lang.sh /etc/profile.d/
USER devuser

###### enable .bashrc.d
RUN echo 'for f in $(ls ~/.bashrc.d/); do source ~/.bashrc.d/$f; done' >> $DEV_HOME/.bashrc && \
	mkdir -p $DEV_HOME/.bashrc.d

CMD bash

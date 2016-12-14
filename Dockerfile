FROM daocloud.io/centos:7.2.1511

###### install tools
RUN yum install -y \
	sudo \
	mount.nfs

###### add user gauss
ENV USER_NAME gauss
ENV USER_HOME /home/$USER_NAME
RUN ( printf 'devuser\ndevuser\n' | passwd ) && \
	useradd $USER_NAME -m && \
	( echo 'gauss    ALL=(ALL)       NOPASSWD:ALL' > /etc/sudoers.d/$USER_NAME ) && \
	sed 's/^Defaults \{1,\}requiretty'//g -i /etc/sudoers

###### set lang
ADD lang.sh /etc/profile.d/

###### mount nfs and in loop
ADD main_loop /usr/local/bin/
RUN sudo chmod +x /usr/local/bin/main_loop

###### tools for install docker
ADD install-docker /usr/local/bin/
RUN chmod +x /usr/local/bin/install-docker

###### proxy for execute shell in login mode
ADD bproxy /usr/local/bin/
RUN sudo chmod +x /usr/local/bin/bproxy

USER $USER_NAME
###### enable user .bashrc.d
RUN echo 'for f in $(ls ~/.bashrc.d/); do source ~/.bashrc.d/$f; done' >> $USER_HOME/.bashrc && \
	mkdir -p $USER_HOME/.bashrc.d

CMD bash

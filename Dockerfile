FROM ubuntu

RUN apt-get update
RUN apt-get install -y maven
RUN apt-get install -y openssh-server
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN service ssh restart
RUN ssh-keygen -N '' -f ~/.ssh/id_rsa
RUN cat /etc/hosts
CMD ["/usr/sbin/sshd", "-D"]

RUN apt-get install -y git
RUN git clone https://github.com/soumithk/MavenTestProject
WORKDIR MavenTestProject

RUN mvn install

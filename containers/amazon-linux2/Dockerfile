FROM amazonlinux:latest

ARG USERNAME=deven

ENV TZ=America/Los_Angeles

# Configure CG apt package libraries ----------------------------------------------------------------------------------
 
RUN yum update -y
RUN yum install ca-certificates

# Install Utilities ---------------------------------------------------------------------------------------------------

SHELL ["/usr/bin/bash", "-c"]

RUN yum install -y git unzip tar sudo wget curl vim openssh-server
 
# Install Git ---------------------------------------------------------------------------------------------------------
 
RUN yum install -y install git
# RUN git config --global http.sslCAInfo /cacert.pem
 
# Install Docker ------------------------------------------------------------------------------------------------------
 
RUN amazon-linux-extras install docker
RUN systemctl enable docker

# RUN curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
# RUN chmod +x /usr/local/bin/docker-compose
# RUN ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
 
# Create user ----------------------------------------------------------------------------------

RUN groupadd --gid 1000 ${USERNAME} \
    && useradd --uid 1000 --gid 1000 -m ${USERNAME} \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL >> /etc/sudoers \
    && chmod 0440 /etc/sudoers

# Install awscli v2 ---------------------------------------------------------------------------------------------------
 
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
RUN unzip awscliv2.zip
RUN sudo ./aws/install

# Install Python ------------------------------------------------------------------------------------------------------

# RUN amazon-linux-extras install python3.8
RUN yum install python3-pip -y

ARG PYTHON_VERSION=3.9.6

RUN yum install gcc openssl-devel bzip2-devel libffi-devel make -y
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz -O /opt/Python-${PYTHON_VERSION}.tgz
RUN tar xvf /opt/Python-${PYTHON_VERSION}.tgz --directory /opt/
RUN /opt/Python-${PYTHON_VERSION}/configure --enable-optimizations
RUN cd /opt/Python-${PYTHON_VERSION}/
RUN make altinstall

# RUN psudo apip config --user set global.index https://cgrepo.capgroup.com/repository/cgpypi/pypi
# RUN pip config --user set global.index-url https://cgrepo.capgroup.com/repository/cgpypi/simple
# RUN pip config --user set global.trusted-host cgrepo.capgroup.com
 
# Install NodeJS ------------------------------------------------------------------------------------------------------

USER ${USERNAME}
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
RUN . ~/.nvm/nvm.sh && nvm install node
USER root

## Install Terraform --------------------------------------------------------------------------------------------------
 
RUN wget https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip
RUN unzip terraform_1.0.11_linux_amd64.zip
RUN mv terraform /usr/local/bin
 
# Install gimme-aws-creds ---------------------------------------------------------------------------------------------

RUN pip3 install --upgrade gimme-aws-creds

# Create deven user --------------------------------------------------------------------------------------------------
 
# RUN groupadd --gid 1000 ${USERNAME} \
#     && useradd --uid 1000 --gid 1000 -m ${USERNAME} \
#     && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL >> /etc/sudoers \
#     && chmod 0440 /etc/sudoers

USER root

RUN usermod -a -G docker ${USERNAME}
RUN usermod --shell /bin/bash ${USERNAME}

RUN mkdir /var/run/sshd
RUN echo ${USERNAME}:${USERNAME} | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
EXPOSE 22

SHELL ["/usr/bin/bash", "-c"]
ENV SHELL /usr/bin/bash
 
ADD --chown=${USERNAME}:${USERNAME} dotfiles/* /home/${USERNAME}/
ADD --chown=${USERNAME}:${USERNAME} scripts/* /usr/local/bin/

RUN mkdir -p /home/${USERNAME}/.ssh && \
    chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh && \
    chmod 700 /home/${USERNAME}/.ssh

RUN ssh-keygen -f /home/${USERNAME}/.ssh/id_rsa -b 4096
RUN chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh/*
RUN touch /home/${USERNAME}/.ssh/authorized_keys
RUN cat /home/${USERNAME}/.ssh/id_rsa.pub >> /home/${USERNAME}/.ssh/authorized_keys

RUN /usr/bin/ssh-keygen -A 

CMD ["/usr/sbin/sshd", "-D"]
 
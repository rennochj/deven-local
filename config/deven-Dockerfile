FROM ubuntu:focal

ARG USERNAME=deven

ENV TZ=America/Los_Angeles
 
# Configure CG apt package libraries ----------------------------------------------------------------------------------
 
RUN apt-get clean && apt-get update
RUN apt-get -y install ca-certificates

RUN apt-get -y install sudo
 
# Install Utilities ---------------------------------------------------------------------------------------------------
 
RUN DEBIAN_FRONTEND=noninteractive apt -y install wget curl zsh unzip vim snap 
RUN apt-get update && apt-get install -y openssh-server
 
# Install Git ---------------------------------------------------------------------------------------------------------
 
RUN apt -y install git
# RUN git config --global http.sslCAInfo /cacert.pem
 
# Install Docker ------------------------------------------------------------------------------------------------------
 
RUN DEBIAN_FRONTEND=noninteractive apt -y install docker.io docker
RUN curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
 
# Install Python ------------------------------------------------------------------------------------------------------
 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python3.9 python3-pip
# RUN psudo apip config --user set global.index https://cgrepo.capgroup.com/repository/cgpypi/pypi
# RUN pip config --user set global.index-url https://cgrepo.capgroup.com/repository/cgpypi/simple
# RUN pip config --user set global.trusted-host cgrepo.capgroup.com
 
# Install NodeJS ------------------------------------------------------------------------------------------------------
 
RUN DEBIAN_FRONTEND=noninteractive apt -y install nodejs yarn npm
# RUN npm config set registry https://cgrepo.capgroup.com/repository/cgnpm/   
 
# Install awscli v2 ---------------------------------------------------------------------------------------------------
 
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install
 
## Install Terraform --------------------------------------------------------------------------------------------------
 
RUN wget https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip
RUN unzip terraform_1.0.11_linux_amd64.zip
RUN mv terraform /usr/local/bin
 
# Install gimme-aws-creds ---------------------------------------------------------------------------------------------
 
RUN pip3 install --upgrade gimme-aws-creds
 
# Create deven user --------------------------------------------------------------------------------------------------
 
RUN groupadd --gid 1000 ${USERNAME} \
    && useradd --uid 1000 --gid 1000 -m ${USERNAME} \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL >> /etc/sudoers \
    && chmod 0440 /etc/sudoers
 
RUN usermod -a -G docker ${USERNAME}
RUN usermod --shell /bin/bash ${USERNAME}

RUN mkdir /var/run/sshd
# RUN echo ${USERNAME}:${USERNAME} | chpasswd
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

CMD ["/usr/sbin/sshd", "-D"]
 
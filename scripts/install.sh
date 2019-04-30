#!/bin/bash
set -x

if [ -e /etc/redhat-release ] ; then
  REDHAT_BASED=true
fi

TERRAFORM_VERSION="0.11.13"
PACKER_VERSION="1.4.0"
# create new ssh key
[[ ! -f /home/ubuntu/.ssh/mykey ]] \
&& mkdir -p /home/ubuntu/.ssh \
&& ssh-keygen -f /home/ubuntu/.ssh/mykey -N '' \
&& chown -R ubuntu:ubuntu /home/ubuntu/.ssh

# install packages
if [ ${REDHAT_BASED} ] ; then
  yum -y update
  yum install -y docker ansible unzip wget
else 
  apt-get update
  apt-get -y install docker.io ansible unzip python3-pip #python-pip
fi
# add docker privileges
usermod -G docker vagrant

# install pip
pip3 install -U pip

if [[ $? == 127 ]]; then
    # apt-get -y install python-pip
    # pip2 install --upgrade pip
    apt-get -y install python3-pip
    pip3 install --upgrade pip
fi

# for Language Setting
cat >> /etc/bash.bashrc<<EOF
set input-meta on
set output-meta on
set convert-meta off
EOF
# apt-get install -y \
#     locales \
#     language-pack-fi  \
#     language-pack-en && \
#     export LANGUAGE=en_US.UTF-8 && \
#     export LANG=en_US.UTF-8 && \
#     export LC_ALL=en_US.UTF-8 && \
#     locale-gen en_US.UTF-8 && \
#     dpkg-reconfigure locales

# locale-gen ko_KR.UTF-8    
echo "export LC_ALL=C.UTF-8" >> /etc/bash.bashrc
    



# install awscli and ebcli
pip3 install -U awscli
pip3 install -U awsebcli

#terraform
T_VERSION=$(/usr/local/bin/terraform -v | head -1 | cut -d ' ' -f 2 | tail -c +2)
T_RETVAL=${PIPESTATUS[0]}

[[ $T_VERSION != $TERRAFORM_VERSION ]] || [[ $T_RETVAL != 0 ]] \
&& wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# packer
P_VERSION=$(/usr/local/bin/packer -v)
P_RETVAL=$?

[[ $P_VERSION != $PACKER_VERSION ]] || [[ $P_RETVAL != 1 ]] \
&& wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
&& unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm packer_${PACKER_VERSION}_linux_amd64.zip

# clean up
if [ ! ${REDHAT_BASED} ] ; then
  apt-get clean
fi

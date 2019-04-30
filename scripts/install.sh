#!/bin/bash

TERRAFORM_VERSION="0.11.13"
PACKER_VERSION="1.4.0"

# System Variable Setting
export LC_ALL=C.UTF-8
export DEBIAN_FRONTEND=noninteractive
echo "export LC_ALL=C.UTF-8">>/etc/bash.bashrc
echo "export DEBIAN_FRONTEND=noninteractive">>/etc/bash.bashrc


# create new ssh key
[[ ! -f /home/vagrant/.ssh/mykey ]] \
&& mkdir -p /home/vagrant/.ssh \
&& ssh-keygen -f /home/vagrant/.ssh/mykey -N '' \
&& chown -R vagrant:vagrant /home/vagrant/.ssh


# install packages
apt-get update
apt-get -y install docker.io ansible unzip 
## add docker privileges
usermod -G docker vagrant

# install pip
apt-get -y install python3-pip
python3 -m pip install --user --upgrade pip

# install awscli and ebcli
python3 -m pip install  awscli
python3 -m pip install  awsebcli

## pip upgrade for pip3 command
# echo "y"|python3 -m pip uninstall pip 
# apt-get install python3-pip   --reinstall
# pip3 install --user --upgrade pip


# for Language Setting
cat <<EOF>> /etc/bash.bashrc
set input-meta on
set output-meta on
set convert-meta off
EOF

echo "export LC_ALL=C.UTF-8" >> /etc/bash.bashrc


# install terraform
T_VERSION=$(/usr/local/bin/terraform -v | head -1 | cut -d ' ' -f 2 | tail -c +2)
T_RETVAL=${PIPESTATUS[0]}

[[ $T_VERSION != $TERRAFORM_VERSION ]] || [[ $T_RETVAL != 0 ]] \
&& wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# install packer
P_VERSION=$(/usr/local/bin/packer -v)
P_RETVAL=$?

[[ $P_VERSION != $PACKER_VERSION ]] || [[ $P_RETVAL != 1 ]] \
&& wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
&& unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm packer_${PACKER_VERSION}_linux_amd64.zip


# Setting for Convenient
## Enable ssh
echo PasswordAuthentication yes >> /etc/ssh/ssh_config

## Easy "cd" to share folder
cmd='cd /vagrant/forVm'
echo "alias v=\"echo '$cmd';$cmd\"">>/etc/bash.bashrc

## Easy Terraform apply
cmd='
terraform destroy -auto-approve
terraform init 
terraform apply -auto-approve
cat terraform.tfstate|grep public_ip|grep -v associate
'
echo "alias ta=\"echo '$cmd';$cmd\"">>/etc/bash.bashrc

## Easy Terraform destroy
cmd='terraform destroy -auto-approve'
echo "alias td=\"echo '$cmd';$cmd\"">>/etc/bash.bashrc

# clean up
apt-get clean

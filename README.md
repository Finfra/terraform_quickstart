

# Orginal Source Code
* [https://github.com/wardviaene/devops-box](https://github.com/wardviaene/devops-box)


# DevOps box
* A vagrant project with an ubuntu box with the tools needed to do DevOps

# Usage1 : Install on Ec2 Instacne
```
sudo -i
git clone http://github.com/finfra/terraform-quickstart.git
. terraform-quickstart/scripts/installOnEc2.sh
exit
echo 'export AWS_ACCESS_KEY_ID="xxxxxxxxxxxx"'                          >> ~/.bashrc
echo 'export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"'  >> ~/.bashrc
. ~/.bashrc
  

```
# Usage2 : Vagrant
```
git clone http://github.com/finfra/terraform-quickstart.git
cd terraform-quickstart
vagrant destroy -f ;vagrant up;vagrant ssh
```

# Alias
## "cd" to share folder
* v
```
cd /vagrant/forVm
```

## Terraform Apply
* ta
```
terraform destroy -auto-approve
terraform init
terraform apply -auto-approve
cat terraform.tfstate|grep public_ip|grep -v associate
```

## Terraform Destroy
* td
```
terraform destroy -auto-approve
```

## Delete aws Key pair
* dk
```
aws ec2 delete-key-pair --key-name mykey
```


# tools included
* Terraform
* git
* AWS CLI
* AWS Elastic Beanstalk CLI
* Packer
* Docker
* python3
* Ansible

# ToDo
* Apply AutoComplete
```
terraform -install-autocomplete
```

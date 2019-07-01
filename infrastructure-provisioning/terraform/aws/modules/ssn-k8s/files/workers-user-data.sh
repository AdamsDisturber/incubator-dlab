#!/bin/bash
set -e

check_tokens () {
RUN=`aws s3 ls s3://${k8s-bucket-name}/k8s/masters/ > /dev/null && echo "true" || echo "false"`
sleep 5
}

# Creating DLab user
sudo useradd -m -G sudo -s /bin/bash ${k8s-os-user}
sudo bash -c 'echo "${k8s-os-user} ALL = NOPASSWD:ALL" >> /etc/sudoers'
sudo mkdir /home/${k8s-os-user}/.ssh
sudo bash -c 'cat /home/ubuntu/.ssh/authorized_keys > /home/${k8s-os-user}/.ssh/authorized_keys'
sudo chown -R ${k8s-os-user}:${k8s-os-user} /home/${k8s-os-user}/
sudo chmod 700 /home/${k8s-os-user}/.ssh
sudo chmod 600 /home/${k8s-os-user}/.ssh/authorized_keys

sudo apt-get update
sudo apt-get install -y python-pip
sudo pip install -U pip
sudo pip install awscli

# installing Docker
sudo bash -c 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -'
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo systemctl enable docker
# installing kubeadm, kubelet and kubectl
sudo apt-get install -y apt-transport-https curl
sudo bash -c 'curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -'
sudo bash -c 'echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
while check_tokens
do
    if [[ $RUN == "false" ]];
    then
        echo "Waiting for initial cluster initialization..."
    else
        echo "Initial cluster initialized!"
        break
    fi
done
aws s3 cp s3://${k8s-bucket-name}/k8s/masters/join_command /tmp/join_command
join_command=`cat /tmp/join_command`
sudo $join_command

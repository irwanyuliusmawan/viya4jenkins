# Viya4 Jenkins for Deployment Automation and Disaster Recovery Setup
Jenkins is an open-source automation tool written in Java with plugins built for Continuous Integration purposes. This project uses Jenkins to automate the Viya4 Infra Setup on Cloud and Deployment. It can also be used for some of the automated script like Disaster Recovery.

## Prerequisite
### Spawn the Ubuntu machine on Any Cloud Provider
### Java Setup

```bash
sudo apt update
sudo apt install default-jre
sudo apt install default-jdk
sudo update-alternatives --config java
javac -version
```

### Python Setup

```bash
sudo apt-get install python3 -y
sudo apt install python3-pip
```
### Jenkins Setup

```bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo ufw allow 8080
sudo ufw status
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
### Docker Setup

```bash
sudo apt-get update
sudo apt-get install     ca-certificates     curl     gnupg     lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
docker version
sudo usermod -aG docker jenkins
sudo usermod -aG docker admin
sudo usermod -aG docker ubuntu
```
### kubectl Setup

```bash
curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl
curl -LO "https://dl.k8s.io/v1.21.0/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

### jq and yq Setup

```bash
sudo apt install -y jq
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod a+x /usr/local/bin/yq
jq --version
yq --version
```

### SSHPass Setup

```bash
sudo apt-get install sshpass
```
### Kustomize Setup

```bash
sudo wget https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh && sudo chmod a+x install_kustomize.sh && ./install_kustomize.sh 3.7.0 && sudo mv kustomize /usr/bin/kustomize && sudo rm -r kustomize
```
### AWS CLI and eksctl setup

```bash
sudo apt  install awscli
eksctl version
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin
eksctl version
eksctl completion bash >> ~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion
```

### Azure CLI

```bash
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install -y python3.7
sudo apt-get install -y libffi-dev
sudo apt-get install -y libssl-dev
sudo curl -L https://aka.ms/InstallAzureCli | bash
sudo mv bin/az /usr/bin/
az --version
```
### GCloud CLI

```bash
sudo apt-get install apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-cli
gcloud --version
```

## Setup the Docker Images
### viya4-iac-aws 
Clone / Download the viya4-iac-aws project from github and then build docker image. This need to be setup on Host machine were you have setup jenkins.
```
cd ~

# clone the viya4-iac-aws repo
git clone https://github.com/sassoftware/viya4-iac-aws

cd ~/viya4-iac-aws

# Build the viya4-iac-aws container
docker build -t viya4-iac-aws .
```

### viya4-iac-azure 
Clone / Download the viya4-iac-azure project from github and then build docker image. This need to be setup on Host machine were you have setup jenkins.

```
cd ~

# clone the viya4-iac-aws repo
git clone https://github.com/sassoftware/viya4-iac-azure

cd ~/viya4-iac-azure

# Build the viya4-iac-azure container
docker build -t viya4-iac-azure .
```

### viya4-iac-gcp
Clone / Download the viya4-iac-gcp project from github and then build docker image. This need to be setup on Host machine were you have setup jenkins.

```
cd ~

# clone the viya4-iac-aws repo
git clone https://github.com/sassoftware/viya4-iac-gcp

cd ~/viya4-iac-gcp

# Build the viya4-iac-gcp container
docker build -t viya4-iac-gcp .
```


### viya4-deployment
Clone / Download the viya4-deployment project from github and then build docker image. This need to be setup on Host machine were you have setup jenkins.

```
cd ~

# clone the viya4-iac-aws repo
git clone https://github.com/sassoftware/viya4-deployment

cd ~/viya4-iac-azure

# Build the viya4-iac-azure container
docker build -t viya4-deployment .
```

## Additonal more Steps on Jenkins Host Machine
1. Create the project folder. Also under project folder also there need to deploy folder.
```
sudo mkdir project
cd project
sudo mkdir deploy
cd ../
sudo chmod -R 777 project
sudo chown -R jenkins:jenkins project
```
2. Create the ssh key on the machine
```
sudo chmod 0700 ~/.ssh
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
```
3. Create .ssh and .kube in /var/lib/jenkins
```
cd /var/lib/jenkins
mkdir .ssh
mkdir .kube
sudo chmod -R 777 .ssh
sudo chmod -R 777 .kube
sudo chown -R jenkins:jenkins .ssh
sudo chown -R jenkins:jenkins .kube
```
4. Copy the private key id_rsa from home/ubuntu/.ssh to /var/lib/jenkins/.ssh
```
sudo cp /home/ubuntu/.ssh/id_rsa /var/lib/jenkins/.ssh/id_rsa
sudo chmod 400 /var/lib/jenkins/.ssh/id_rsa
sudo chown jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa
```
5. Create the output.json file
```
sudo touch ~/output.json
sudo chmod 777 output.json
sudo chown ubuntu:ubuntu output.json
```

## Jenkins Pipeline Setup
### Jenkins Setup
Now that Jenkins is installed, start it by using systemctl:
```
sudo systemctl start jenkins.service
```
Check the stats of Jenkins service
```
sudo systemctl status jenkins
```
*** Note Jenkins is started and also you have configured firewall to access port 8080
*** Jenkins url can be accessed as below - http://your_server_ip_or_domain:8080. In this step you will receive you should receive the Unlock Jenkins screen, which displays the location of the initial password:
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
The next screen presents the option of installing suggested plugins or selecting specific plugins. We’ll click the Install suggested plugins option, which will immediately begin the installation process. When the installation is complete, you’ll be prompted to set up the first administrative user. It’s possible to skip this step and continue as admin using the initial password from above, but we’ll take a moment to create the user.

### Jenkins Plugin Setup
Once Jenkins is configured after that it can be logged in to install required plugin
Goto Manage Jenkins -> Plugin Manager. Here go to "Available" tab and select plugin like ssh-agent, ssh, docker pipeline, kubernetes and Maven pipeline.
Once Plugin are applied you can select to Restart Jenkins.

### Adding Credntials in Jenkins
Goto Manage Jenkins -> Manage Credentials (In Security Tab) -> Here add 2 credentials as below
1. Git Repo Credentials
2. SSH Private key

### Proivide the admin access to Jenkin user
Goto Manage Jenkins -> Configure Global Security, apply below security settings
- Security Realm - Jenkins own user database
- Check Allow users to Sign up
- Authorization - Matrix Based Security, Add user which you created and give user Administer access

### Create the Pipeline for Automation
- Goto Dashboard -> New Item -> Enter Item Name -> Select Pipeline -> Click OK
- Select checkbox Github project and provide the project url
- In Pipeline in Definition, Select Pipeline script from SCM, Provide Reporsitory URL and credentials, Also select the branch were you have pipeline file saved.

## Execute the below Pipeline
Select the Item which you created and Click on Build Now.

### Viya4 Complete Environment Creation and Deployment on AWS, Azure or GCloud
The Viya4 Complete Environment cretion is Jenkins Pipeline which will create end to end new environment for Viya 4
- Spawn the new infrastructure using  Terraform
- NFS Directory Creation
- Get the Environment Details of newly created infrastructure
- Deployment on Viya 4

### Viya4 Trigger New Changes
This pipeline will deploy new changes to Viya 4 Environment.

### Viya4 Trigger Validation Test
This Pipeline runs the Selenium Test cases whenever required on the server.

### Viya4 DR Environment Creation and Deployment on AWS, Azure or Google
This pipeline can be used to create the new DR environment in new availability zone and then restore the build. This will be automated build which will creat new environment and then restore the backups.

**Prerequisites**
- Backup for CAS and Postgres need to scheduled to NFS Server. Schedule could be weekly or daily basis on RPO requirement.
- NFS Server should be highly available so that the Backup data is not lost.
- Need to Find the Backup ID

**Steps if need to trigger the DR**
- Spawn the new Environment by using JenkinsDR pipeline
- Existing NFS Directory Provisioning to Cluster
- Deploying SAS Viya 4 Environment on newly created Environment 
- Restore the SAS Viya 4 onto newly deployed SAS Viya 4 environment.

**Note**
- CAS Data need to reloaded as restore will only take care of CAS data.
- NFS Server data should be available as backup files will stored there itself
- DR Execution might take around 2-3 hours in this process so RTO so basis of that.
- Domain name requires to updated as new IP Address might get generated, This will be manual process.
- Reference of Restore is taken from here - https://gitlab.sas.com/GEL/workshops/PSGEL260-sas-viya-4.0.1-administration/-/blob/main/03_Initial_Configuration/03_021_Mount_NFS_to_Viya.md 

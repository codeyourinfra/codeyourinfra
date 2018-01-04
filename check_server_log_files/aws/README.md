# AWS support

The steps to experiment the solution's environment on AWS are as follows:

#### 1. Setup

If you haven't already executed, run `$ ansible-playbook ../../cloud/aws/playbook-aws-region-configuration.yml`. Choose the AWS region where the EC2 instances will be created in by Vagrant.

#### 2. Initialization

Then, just run `$ vagrant up`. If you have already configured the [AWS CLI tool](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html), the default region defined in the **~/.aws/config** file will be used, otherwise set the **AWS_REGION** or the **EC2_REGION** environment variable with the region of your prior choice.

The Vagrant commands will also take into consideration the **APPEND_TIMESTAMP** and the **PROVISIONING_OPTION** environment variables, introduced in the Codeyourinfra project's [release 1.4.0](https://github.com/esign-consulting/codeyourinfra/releases/tag/1.4.0).

#### 3. Inventory

Right after the EC2 instances creation, run `$ ansible-playbook playbook-ec2-instances-inventory.yml`. The **ec2_hosts** file is so generated with the correct **jenkins** server's IP address.

#### 4. Testing

Finally, execute `$ ansible-playbook ../playbook-jenkins-logs.yml -i ec2_hosts`. The Jenkins' log file is so be made available through the web browser.

#### 5. Validation

To validate, run `$ wget http://<jenkins_ip_address>/logs/jenkins/jenkins.log`, replacing *<jenkins_ip_address>* by the IP address of the **jenkins** server, stored in the **ec2_hosts** file. The **jenkins.log** file must be downloaded from the **jenkins** server.
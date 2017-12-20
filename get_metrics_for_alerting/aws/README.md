# AWS support

The steps to experiment the solution's environment on AWS are as follows:

#### 1. Setup

If you haven't already executed, run `$ ansible-playbook ../../cloud/aws/playbook-aws-region-configuration.yml`. Choose the AWS region where the EC2 instances will be created in by Vagrant.

#### 2. Initialization

Then, just run `$ vagrant up`. If you have already configured the [AWS CLI tool](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html), the default region defined in the **~/.aws/config** file will be used, otherwise set the **AWS_REGION** or the **EC2_REGION** environment variable with the region of your prior choice.

The Vagrant commands will also take into consideration the **APPEND_TIMESTAMP** and the **PROVISIONING_OPTION** environment variables, introduced in the Codeyourinfra project's [release 1.4.0](https://github.com/esign-consulting/codeyourinfra/tree/1.4.0).

#### 3. Inventory

Right after the EC2 instances creation, run `$ ansible-playbook playbook-ec2-instances-inventory.yml`. The **ec2_hosts** file is so generated with the correct servers' (**monitor**, **server1** and **server2**) IP addresses.

#### 4. Testing

Before adding a server to the monitoring service, copy the private SSH key to the current directory: `$ cp ../../cloud/aws/<aws_region>/codeyourinfra-aws-key.pem .`, replacing *<aws_region>* by the AWS region of your choice.

Finally, execute `$ ansible-playbook ../playbook-add-server.yml -i ec2_hosts -e "host=<server1_ip_address> user=ubuntu private_key=aws/codeyourinfra-aws-key.pem"`, replacing the *<server1_ip_address>* by the **server1** IP address, obtained from AWS and stored in the **ec2_hosts** file.

Do the same for **server2**.

#### 5. Validation

To validate, run `$ ansible monitor -i ec2_hosts -m shell -a "cat /etc/ansible/playbooks/playbook-get-metrics.log"`. The playbook responsible for collecting metrics from the monitored servers is executed by CRON every minute. The log file must show the success of such task in both servers (**server1** and **server2**).
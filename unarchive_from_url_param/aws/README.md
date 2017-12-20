# AWS support

The steps to experiment the solution's environment on AWS are as follows:

#### 1. Setup

If you haven't already executed, run `$ ansible-playbook ../../cloud/aws/playbook-aws-region-configuration.yml`. Choose the AWS region where the EC2 instances will be created in by Vagrant.

#### 2. Initialization

Then, just run `$ vagrant up`. If you have already configured the [AWS CLI tool](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html), the default region defined in the **~/.aws/config** file will be used, otherwise set the **AWS_REGION** or the **EC2_REGION** environment variable with the region of your prior choice.

The Vagrant commands will also take into consideration the **APPEND_TIMESTAMP** and the **PROVISIONING_OPTION** environment variables, introduced in the Codeyourinfra project's [release 1.4.0](https://github.com/esign-consulting/codeyourinfra/tree/1.4.0).

#### 3. Inventory

Right after the EC2 instances creation, run `$ ansible-playbook playbook-ec2-instances-inventory.yml`. The **ec2_hosts** file is so generated with the correct servers' (**repo**, **server1** and **server2**) IP addresses.

#### 4. Parameters

In order to get the right **params.json** file, you must then run `$ ansible-playbook playbook-params-json.yml -i ec2_hosts`. It will replace the servers hostnames and the repo IP address by the proper values obtained from AWS.

#### 5. Testing

Finally, execute `$ ansible-playbook ../playbook-servers.yml -i ec2_hosts -e "params_file=aws/params.json"`. Notice that you now pass the parameters file's path as a parameter itself. The compressed files are so extracted in both servers (**server1** and **server2**) in just one shot.

#### 6. Validation

To validate, run `$ ansible servers -i ec2_hosts -m shell -a "ls -la /var/target"`. There must be the Apache Maven 3.5.0 folder in the /var/target directory of **server1** and the Apache Ant 1.10.1 folder in the same directory of **server2**.
# AWS support

The steps to experiment the solution's environment on AWS are as follows:

#### 1. Setup

If you haven't already executed, run `$ ansible-playbook ../../cloud/aws/playbook-aws-region-configuration.yml`. Choose the AWS region where the EC2 instances will be created in by Vagrant.

#### 2. Initialization

Then, just run `$ vagrant up`. If you have already configured the [AWS CLI tool](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html), the default region defined in the **~/.aws/config** file will be used, otherwise set the **AWS_REGION** or the **EC2_REGION** environment variable with the region of your prior choice.

The Vagrant commands will also take into consideration the **APPEND_TIMESTAMP** and the **PROVISIONING_OPTION** environment variables, introduced in the Codeyourinfra project's [release 1.4.0](https://github.com/esign-consulting/codeyourinfra/releases/tag/1.4.0).

#### 3. Inventory

Right after the EC2 instances creation, run `$ ansible-playbook playbook-ec2-instances-inventory.yml`. The **ec2_hosts** file is so generated with the correct servers' (**qa1**, **qa2** and **qa3**) IP addresses.

#### 4. Parameters

In order to get the right **config.json** file, you must then run `$ ansible-playbook playbook-config-json.yml -i ec2_hosts`. It will replace the QA servers hostnames by the proper values obtained from AWS.

#### 5. Testing

Finally, execute `$ ansible-playbook ../playbook.yml -i ec2_hosts -e "config_file=aws/config.json"`. Notice that you now pass the configuration file's path as a parameter. All the servers has its specific configuration updated within a single execution.

#### 6. Validation

To validate, run `$ ansible qa -i ec2_hosts -m shell -a "cat /etc/conf"`. The value of **prop1** in the configuration file of the **qa1** server must be **A**, in the same file of the **qa2** server must be **C**, and in the same file of the **qa3** server must be **E**.
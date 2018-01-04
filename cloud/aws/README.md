# AWS support

Since the [release 1.5.0](https://github.com/esign-consulting/codeyourinfra/releases/tag/1.5.0), the Codeyourinfra project has been providing AWS support. It's explained in detail in the project blog post [Bringing the Ansible development to the cloud](http://codeyourinfra.today/bringing-the-ansible-development-to-the-cloud), but you can follow the instructions below as well.

The same local virtualized environment required for Ansible playbooks' developing and testing then can run in the cloud. The local VirtualBox VMs can be replaced by EC2 instances, if you prefer. And it can be done as simply as executing the usual command `$ vagrant up`, from the **aws** directory of any project's solution.

## AWS Configuration

First of all, you must have an account on [AWS](https://aws.amazon.com). Then, you must have an user created through the **IAM** (Identity and Access Management) console, with full access to the EC2 resources (add the **AmazonEC2FullAccess** permission, for example).

After that, in the **Security credentials** tab, create an access key, from which you will be able to access the EC2 resources. The **access key ID** and the **secret access key** values then can be set to the **AWS_ACCESS_KEY_ID** and the **AWS_SECRET_ACCESS_KEY** environment variables, respectively.

If you prefer, use the [AWS CLI (Command Line Interface) tool](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html), and make this local configuration through the command `$ aws configure`.

## Region configuration

In order to have the EC2 instances created by Vagrant, you must choose an [AWS region](http://docs.aws.amazon.com/general/latest/gr/rande.html) and execute `$ ansible-playbook playbook-aws-region-configuration.yml`.

It's required to be done before the execution of `$ vagrant up`, because it creates in the chosen AWS region the **security group** and the **key pairs** that will be used by Vagrant. A **subnet** and an **Ubuntu image** are also selected, during the playbook-aws-region-configuration.yml execution, to be used by Vagrant for managing the EC2 instances.

You can repeat the execution for different AWS regions. Each region will have a specific subdirectory where the required data will be stored. The only thing you must bear in mind when initializing later the environment is to use the region previously configured.


## Vagrant AWS plugin

Before executing `$ vagrant up` inside any solution's **aws** directory, you must install the Vagrant AWS plugin. Just run `$ vagrant plugin install vagrant-aws`.

If you want more information about the Vagrant AWS plugin, please visit https://github.com/mitchellh/vagrant-aws.

## Inventory step

The use of AWS requires one or more steps for making the environment ready to test the solution, though. Once the new EC2 instances always get new IP addresses, the Ansible inventory file must be dinamicaly generated right after their initialization.

For that reason, each solution comes with a template of the Ansible inventory file (**ec2_hosts_template**) and a playbook responsible for obtaining the EC2 instances' IP addresses from AWS and generating the final inventory file based on the template (**playbook-ec2-instances-inventory.yml**).

After the execution of `$ vagrant up`, just run the command `$ ansible-playbook playbook-ec2-instances-inventory.yml`, and the **ec2_hosts** file will be generated.
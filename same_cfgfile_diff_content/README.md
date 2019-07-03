# Same configuration file with different content in different environments

This solution is explained in detail in the Codeyourinfra project blog post [How to deal with the same configuration file with different content in different environments](http://codeyourinfra.today/how-to-deal-with-the-same-configuration-file-with-different-content-in-different-environments). Check it out!

## Problem

The dev team has to deploy the application in different QA environments. The application requires a properties file where either the database string connection and the database credentials are defined. In each environment they are different. This is just an example of the same configuration file with different content in different environments.

## Solution

Instead of having a version of the same configuration file for each environment, it's possible to keep just one, including all the values required in every environment ([conncfg.yml](conncfg.yml)). This variables are then used during the **same_cfgfile_diff_content** [Ansible role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)'s execution, when the configuration file's content is set, specific to each environment.

```yml
---
- hosts: qa
  vars_files:
    - conncfg.yml
  roles:
    - same_cfgfile_diff_content
```

## Test

First of all, turn on the 3 VMs that represent the QA environments, executing the command `$ vagrant up`. After that, execute the command `$ ansible-playbook playbook.yml`. Finally, in order to check the configuration file's content of every environment, execute the command `$ ansible qa -m shell -a "cat /etc/conn.properties"`.

### Automated tests

You can also test the solution automaticaly, by executing `./test.sh` or using [Molecule](https://molecule.readthedocs.io). With the latter, you can perform the test not only locally (the default), but in [AWS](https://aws.amazon.com) as well. During the Codeyourinfra's *continuous integration* process in Travis CI, the solution is tested on [Amazon EC2](https://aws.amazon.com/ec2).

In order to get your environment ready for using *Molecule*, prepare your [Python virtual environment](https://docs.python.org/3/tutorial/venv.html), executing `python3 -m venv env && source env/bin/activate && pip install -r ../requirements.txt`. After that, just run the command `molecule test`, to test the solution locally in a [VirtualBox](https://www.virtualbox.org) VM managed by [Vagrant](https://www.vagrantup.com).

If you prefer performing the test in AWS, bear in mind you must have your credentials appropriately in **~/.aws/credentials**. You can [configure it through the AWS CLI tool](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html). The test is performed in the AWS region *Europe - London (eu-west-2)*. Just run `molecule test -s aws` and check the running instances through your [AWS Console](https://eu-west-2.console.aws.amazon.com/ec2/v2).

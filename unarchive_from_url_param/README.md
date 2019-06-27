# Unarchive different remote files in different target servers

This solution is explained in detail in the Codeyourinfra project blog post [How to unarchive different files in different servers in just one shot](http://codeyourinfra.today/how-to-unarchive-different-files-in-different-servers-in-just-one-shot). Check it out!

## Problem

You have a bunch of servers and quite often you have to manually extract in each one a specific compressed file. It works well when there's not too many servers to change, but such task becomes really boring and even error-prone when it reaches, say, a hundred servers or more. How can it be done in scale?

## Solution

**unarchive_from_url_param** is an example of [Ansible role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) which makes it possible. You just need to pass the parameters appropriately. For each server, the role expects a **url** from where the compressed file is downloaded and a **target** directory to where the content is extracted. All the hosts that are defined inside the **servers** group in the [Ansible inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) are considered on a single execution.

```yml
---
- hosts: servers
  roles:
    - role: unarchive_from_url_param
      vars:
        params:
          server1:
            url: https://archive.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz
            target: /opt/maven
          server2:
            url: https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.1-bin.zip
            target: /opt/ant
```

## Test

First of all, turn on the VMs, executing the command `$ vagrant up`. Once the test environment is up, execute the command `$ ansible-playbook playbook.yml`. Finally, in order to check if the compressed files were properly extracted in both servers, execute the command `$ ansible servers -m shell -a "ls /var/target"`.

### Automated tests

You can also test the solution automaticaly, by executing `./test.sh` or using [Molecule](https://molecule.readthedocs.io). With the latter, you can perform the test not only locally (the default), but in [AWS](https://aws.amazon.com) as well. During the Codeyourinfra's *continuous integration* process in Travis CI, the solution is tested on [Amazon EC2](https://aws.amazon.com/ec2).

In order to get your environment ready for using *Molecule*, prepare your [Python virtual environment](https://docs.python.org/3/tutorial/venv.html), executing `python3 -m venv env && source env/bin/activate && pip install -r ../requirements.txt`. After that, just run the command `molecule test`, to test the solution locally in a [VirtualBox](https://www.virtualbox.org) VM managed by [Vagrant](https://www.vagrantup.com).

If you prefer performing the test in AWS, bear in mind you must have your credentials appropriately in **~/.aws/credentials**. You can [configure it through the AWS CLI tool](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html). The test is performed in the AWS region *Europe - London (eu-west-2)*. Just run `molecule test -s aws` and check the running instances through your [AWS Console](https://eu-west-2.console.aws.amazon.com/ec2/v2).

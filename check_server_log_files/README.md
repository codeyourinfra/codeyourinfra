# Check log files in a server through the web browser

This solution is explained in detail in the Codeyourinfra project blog post [How to check log files in a server without logging in the server](http://codeyourinfra.today/how-to-check-log-files-in-a-server-without-logging-in-the-server). Check it out!

## Problem

The developers are always requesting you the applications' log files, for troubleshooting purposes. The company's security policies determine that they can't log in the server where the files are. You're tired of sending the files by email to the developers all day long.

## Solution

Make the log files available through the web browser! The [playbook.yml](playbook.yml) is an example of Ansible playbook which makes that for you. When executed, the playbook installs and configures the [Apache HTTP Server](https://httpd.apache.org) in a way that the Jenkins log files become accessible through the browser. Set accordingly the variables and you can easily make the same for any application you wish.

## Test

First of all, run the command `vagrant up`, in order to turn on the **jenkins server**. After that, execute the command `ansible-playbook playbook.yml -i hosts`. Finally, open your web browser and access the Jenkins log files through the **URL** http://192.168.33.10/logs/jenkins. Alternativelly, download the Jenkins log file through the command `wget http://192.168.33.10/logs/jenkins/jenkins.log`.

### Automated tests

You can also test the solution automaticaly, by executing `./test.sh` or using [Molecule](https://molecule.readthedocs.io). With the latter, you can perform the test not only locally (the default), but in [AWS](https://aws.amazon.com) as well. During the Codeyourinfra's *continuous integration* process in Travis CI, the solution is tested in a [EC2 instance](https://aws.amazon.com/ec2).

In order to get your environment ready for using *Molecule*, prepare your [Python virtual environment](https://docs.python.org/3/tutorial/venv.html), executing `python3 -m venv env && source env/bin/activate && pip install -r ../requirements.txt`. After that, just run the command `molecule test`, to test the solution locally in a [VirtualBox](https://www.virtualbox.org) VM managed by [Vagrant](https://www.vagrantup.com).

If you prefer performing the test in AWS, bear in mind you must have your credentials appropriately in **~/.aws/credentials**. You can [configure it through the AWS CLI tool](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html). The test is performed in the AWS region *Europe - London (eu-west-2)*. Just run `molecule test -s aws` and check the running instance through your [AWS Console](https://eu-west-2.console.aws.amazon.com/ec2/v2).
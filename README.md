# The Codeyourinfra project

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![GitHub release](https://img.shields.io/github/release/esign-consulting/codeyourinfra.svg)]()

The Codeyourinfra project aims to bring dev tools and practices to the ops world. The objective is to help sysadmins in gradually adopting tools like [Ansible](https://www.ansible.com), [Vagrant](https://www.vagrantup.com), [GIT](https://git-scm.com) and [Jenkins](https://jenkins.io), and practices like coding, testing, versioning and deploying the infrastructure.

## Giving solutions

The project addresses sysadmins' common pain points, giving solutions that use such tools and practices. The solutions are all explained in detail at the [project website](http://codeyourinfra.today), and placed each one in a subdirectory of this repository. They are as follows:

* [Unarchive different remote files in different target servers](https://github.com/esign-consulting/codeyourinfra/tree/master/unarchive_from_url_param)
* [Same configuration file with different content in different environments](https://github.com/esign-consulting/codeyourinfra/tree/master/same_cfgfile_diff_content)
* [Check log files in a server through the web browser](https://github.com/esign-consulting/codeyourinfra/tree/master/check_server_log_files)
* [Get metrics for alerting in advance and preventing trouble](https://github.com/esign-consulting/codeyourinfra/tree/master/get_metrics_for_alerting)

## How to contribute

The project is totally open for collaboration, like any other open source project. It's an work in progress, needing constant feedbacks in order to improve continuously. You can collaborate in different ways, here's a list of suggestions:

* Cloning this repository in order to validate the solutions
* Making a pull request of a solution improvement
* Commenting on the articles posted on the [blog](http://codeyourinfra.today/blog)
* Telling the [problems](http://codeyourinfra.today/your-problem) you face as a sysadmin

## The development environment

Every development requires an environment for testing. The Codeyourinfra project's solutions have each one a local environment where the tests can be done. The local environment is composed by virtual machines that simulates the scenario with the problem to be solved. The local VMs are managed by [Vagrant](https://www.vagrantup.com), which uses [VirtualBox](https://www.virtualbox.org/) as the [hypervisor](https://en.wikipedia.org/wiki/Hypervisor).

The [release 1.5.0](https://github.com/esign-consulting/codeyourinfra/releases/tag/1.5.0) of the project [brought the Ansible development to the cloud](http://codeyourinfra.today/bringing-the-ansible-development-to-the-cloud). Besides local VMs, remote [AWS EC2](https://aws.amazon.com/ec2) instances became an option for testing the solution. Each solution got an **aws** folder from where the AWS environment can be managed. The same way as initializing local VMs, initializing EC2 instances is as simple as executing the command `$ vagrant up`.

### Environment variables

Since the [release 1.4.0](https://github.com/esign-consulting/codeyourinfra/releases/tag/1.4.0), the Codeyourinfra project has been providing environment variables for changing the default behaviour of the development environment initialization. They are as follows:

Environment variable | Required | Default | Choices | Comments
-------------------- | -------- | ------- | ------- | --------
APPEND_TIMESTAMP | No | false | true or false | If 'true', prepend the current datetime in each line of the vagrant command output.
PROVISIONING_OPTION | No | fried | baked or fried | If 'baked', a previously prepared [Vagrant box](https://www.vagrantup.com/docs/boxes.html) or [AWS AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) is used, rather than the default one that requires to be provisioned from the scratch.

### Testing the solution

The [release 1.6.0](https://github.com/esign-consulting/codeyourinfra/releases/tag/1.6.0) of the project made easier validating the solutions, by automating the tests. The tests then can be done either manually, through the command line, or automatically, by running the shell script **test.sh**.

The script file of the solution root folder, if executed, uses the local environment. Likewise, the one inside the **aws** subdirectory, if executed, uses the AWS environment. They follow basically the steps below:
1. environment boot up
2. Ansible playbooks syntax check
3. auxiliary playbooks execution (if required)
4. solution playbook execution
5. solution validation
6. environment teardown

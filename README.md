# The Codeyourinfra project

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![GitHub release](https://img.shields.io/github/release/codeyourinfra/codeyourinfra.svg)](https://github.com/codeyourinfra/codeyourinfra/releases/latest)

The Codeyourinfra project aims to bring dev tools and practices to the ops world. The objective is to help sysadmins in gradually adopting tools like [Ansible](https://www.ansible.com), [Vagrant](https://www.vagrantup.com), [GIT](https://git-scm.com) and [Jenkins](https://jenkins.io), and practices like coding, testing, versioning and deploying the infrastructure.

## Giving solutions

The project addresses sysadmins' common pain points, giving solutions that use such tools and practices. The solutions are all explained in detail at the [project website](http://codeyourinfra.today), and maintained each one in its repository. They are as follows:

* [Unarchive different remote files in different target servers](https://github.com/codeyourinfra/unarchive_from_url_param)
* [Same configuration file with different content in different environments](https://github.com/codeyourinfra/same_cfgfile_diff_content)
* [Check log files in a server through the web browser](https://github.com/codeyourinfra/check_server_log_files)
* [Get metrics for alerting in advance and preventing trouble](https://github.com/codeyourinfra/get_metrics_for_alerting)

## How to contribute

The project is totally open for collaboration, like any other open source project. It's an work in progress, needing constant feedbacks in order to improve continuously. You can collaborate in different ways, here's a list of suggestions:

* Cloning this repository in order to validate the solutions
* Making a pull request of a new solution or a solution fix/improvement
* Commenting on the articles posted on the [blog](http://codeyourinfra.today/blog)
* Telling the [problems](http://codeyourinfra.today/your-problem) you face as a sysadmin

## Release 2.0

The Codeyourinfra project was totally refactored. Here are the main changes implemented for the [version 2.0](https://github.com/codeyourinfra/codeyourinfra/tree/2.0):

* Each solution now has [its own repository](https://github.com/search?q=topic%3Acodeyourinfra+org%3Acodeyourinfra&type=Repositories)
* Most of them was transformed into [Ansible Roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
* All solutions started to be tested with [Molecule](https://molecule.readthedocs.io/en/latest)

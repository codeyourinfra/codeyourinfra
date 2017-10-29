# Same configuration file with different content in different environments

This solution is explained in detail in the Codeyourinfra project blog post [How to deal with the same configuration file with different content in different environments](http://codeyourinfra.today/how-to-deal-with-the-same-configuration-file-with-different-content-in-different-environments). Check it out!

## Problem

The dev team has to deploy the application in different QA environments. The application requires a properties file where the database string connection is defined. In each environment the database string connection is different. That's just an example of the same configuration file with different content in different environments.

## Solution



## Test


### Important


Software | Version
--- | -----
Host OS | OS X El Capitan 10.11.6
VMs OS | Ubuntu 14.04.3 LTS
Vagrant | 2.0.0
VirtualBox | 5.1.30
VirtualBox Extension Pack | 5.1.28
Ansible | 2.4.0.0

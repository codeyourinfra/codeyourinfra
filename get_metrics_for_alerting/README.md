# Get metrics for alerting in advance and preventing trouble

This solution is explained in detail in the Codeyourinfra project blog post [How to get metrics for alerting in advance and preventing trouble](http://codeyourinfra.today/how-to-get-metrics-for-alerting-in-advance-and-preventing-trouble). Check it out!

## Problem

You may already have a monitoring solution. After all, you are responsible for keeping all the IT services available. You don't want to be surprised by an unexpected outage, then you install in every server an agent for collecting relevant data for monitoring purposes. In addition, automatic emails are sent if something is going wrong, you've configured that. The problem is that you can't handle it anymore because you now have more than a thousand of servers to be monitored. Furthermore, people no more give attention to the alerts received by email, due to the big amount of false positive ones.

## Solution

The solution is based on [InfluxDB](https://docs.influxdata.com/influxdb), a high performance time series database, on [Grafana](https://grafana.com/), a time series analytics and monitoring tool, and on [Ansible](https://www.ansible.com/), an agentless automation tool. They are all open source tools and can be easily integrated with each other in order to create a monitoring service. With Ansible is possible to extract the servers' hardware metrics and store them in the InfluxDB ([playbook-get-metrics.yml](playbook-get-metrics.yml)). With Grafana is possible to connect to InfluxDB and show the metrics in a graphical way, define thresholds and configure alerts that can be given through different channels, including instant messaging apps like [Slack](https://slack.com) and [Telegram](https://telegram.org).

## Test

First of all, run the command `$ vagrant up monitor`, in order to turn on the **monitoring server**. Then, open your web browser and access the Grafana web application through the **URL** http://192.168.33.10:3000. The **user** and the **password** are *admin*. After that, click in the **used_mem_pct** dashboard. You will see the **Used memory percentage** line chart, with data from the **monitoring server** itself. An alert is sent to a [Slack workspace](https://mygrafanaalerts.slack.com) (click [here](https://join.slack.com/t/mygrafanaalerts/shared_invite/enQtMjc0OTUyMjgxMzM0LWYyNDU1NWI3OWIxYmFjOGQ0NmNkOTNkOTFhN2NkNjI3Y2E3OWYzNTA2YmE2NTE2MzE1ZDlhYjZkYzFmZWY3ODI) to join) if the last 5 used memory percentage values are grater than or equal to 95%, the defined threshold.

### Important

The test was done in the environment described in the table below.

Software | Version
-------- | -------
Host OS | OS X El Capitan 10.11.6
VMs OS | Ubuntu 14.04.3 LTS
Vagrant | 2.0.0
VirtualBox | 5.1.30
VirtualBox Extension Pack | 5.1.28
Ansible | 2.4.1.0
InfluxDB | 1.4.2
Grafana | 4.6.2

In addition, the test requires Internet connection, for the **minimal/trusty64** Vagrant box downloading. Depending on the Internet connection speed, the test environment can last more than you expect to be up and running, specially for the first time.

### Provisioning options

Since the [release 1.4.0](https://github.com/esign-consulting/codeyourinfra/releases/tag/1.4.0), the Codeyourinfra project has been providing two options for provisioning: **baked** and **fried** (default). If the **monitoring server** is turned on with the **PROVISIONING_OPTION** environment variable set to **baked**, the Vagrant box that will be used is **codeyourinfra/monitor**, instead of the default **minimal/trusty64**.

The tools used by the solution have already been installed in the **codeyourinfra/monitor** Vagrant box, so it's needless to provision it from the scratch, like the **minimal/trusty64** Vagrant box requires. Despite the fact the **codeyourinfra/monitor** Vagrant box is bigger than the **minimal/trusty64** Vagrant box, and it takes longer to download, it is much faster to boot up, as shown by the comparison table below:

PROVISIONING_OPTION | Vagrant box | Size (Mb) | Boot up duration (min)
------------------- | ----------- | --------- | ----------------------
fried (default) | [minimal/trusty64](https://app.vagrantup.com/minimal/boxes/trusty64/versions/14.04.3) | 271 | 5
baked | [codeyourinfra/monitor](https://app.vagrantup.com/codeyourinfra/boxes/monitor/versions/1.0) | 322 | 1

In order to check the durations, set the **APPEND_TIMESTAMP** environment variable to **true**. Then turn on the **monitoring server** twice, each time with a provisoning option. You will be able to follow how long the boot up takes through the `$ vagrant up monitor` command output.

More details you can find in the Codeyourinfra project blog post [Choosing between baked and fried provisioning](http://codeyourinfra.today/choosing-between-baked-and-fried-provisioning).

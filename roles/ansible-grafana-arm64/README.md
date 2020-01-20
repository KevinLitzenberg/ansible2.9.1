Role Name
=========
See:

http://grafana.com/grafana/download?platform=arm brief description of the role goes here.

And:

https://github.com/prometheus/node_exporter/releases/tag/v0.18.1

Requirements
------------
Running on i386. Although this should only be used for testing since there is a complete debian package for i386
 
 > dpkg --add-architecture

Add the repos to /etc/apt/cources.list

deb [arch=amd64] http://ports.ubuntu.com/ bionic main universe
deb [arch=amd64] http://ports.ubuntu.com/ bionic-updates main universe
deb [arch=amd64] http://ports.ubuntu.com/ bionic-security main universe
 


Role Variables
--------------

./defaults/main.yml

Override and upgrade packages


Dependencies
------------

arm64



InstallcPcaybookcample 
--------------
 Grafana on arm64:

[Playbook]
- hosts: "{{ target_host }}"
  remote_user: "{{ target_user }}"
  roles:
    - role: ansible-grafana-arm64

[Playbook Steps]
https://grafana.com/grafana/download?platform=arm

1. install dependencies
> sudo apt-get install -y adduser libfontconfig1

2. get the debian package
> wget https://dl.grafana.com/oss/release/grafana_6.5.2_arm64.deb

3. install .deb package
> sudo dpkg -i grafana_6.5.2_arm64.deb


[Troubleshooting Grafana]

> /usr/sbin/grafana-server --pidfile=/var/run/grafana-server.pid --config=/etc/grafana/grafana.ini --homepath=/usr/share/grafana cfg:default.paths.data=/var/lib/grafana cfg:default.paths.logs=/var/log/grafana cfg:default.paths.plugins=/var/lib/grafana/plugins -profile -profile-port=9090 -tracing -tracing-file=/tmp/trace.out



License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

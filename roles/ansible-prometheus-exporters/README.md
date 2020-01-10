Role Name
=========

Deploys various prometheus exporters.
node_exporter

Requirements
------------

To be used in conjunction with the role ansible-prometheus.

Role Variables
--------------

See defaults/main.yml to overide package versions


Dependencies
------------

Create a Prometheus server that can scrape node_exporter

Example Playbook
----------------

prometheus_exporters_deploy.yml

---
- hosts: "{{ target_host }}"
  remote_user: "{{ target_user }}"
  roles:
    - role: ansible-prometheus-exporters


License
-------

BSD

Author Information
------------------

kevin.litzenberg@gmail.com


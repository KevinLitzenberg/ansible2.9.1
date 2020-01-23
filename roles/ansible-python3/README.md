Role Name
=========

Installs python3.x, ppa deadsnakes, python3.x-dev, python3.x-venv, and a few other essentail tools.

Requirements
------------

A desire to install python3.x on a Ubuntui16.04/18.04 host.


Role Variables
--------------

./default/main.yml python3_ver: version of python3 to install.


Dependencies
------------

ppa deadsnakes

Example Playbook
----------------

 hosts: "{{ target_host }}"
  remote_user: "{{ target_user }}"
  roles:
    - name: ansible-python3
      python3_ver: "python3.8"


License
-------

BSD

Author Information
------------------
kevin.litzenberg@gmail.com


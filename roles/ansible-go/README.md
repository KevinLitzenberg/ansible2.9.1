Role Name
=========

Installs and configures go language

Requirements
------------

This role was written for Ubuntu16.04/18.04 amd64


Role Variables
--------------

go_working_dir: location of the binaries
go_url: WGET binaries
go_src: the go version

go_path: add path to /etc/environment
REGX CREDIT to https://coderwall.com/p/ynvi0q/updating-path-with-ansible-system-wide 	

Dependencies
------------

arch amd64 only 

[TO DO]: add logic for more binaries.

Example Playbook
----------------

- hosts: "{{ target_host }}"
  remote_user: "{{ target_user }}"
  roles:
    - name: ansible-go


License
-------

BSD

Author Information
------------------
kevin.litzenberg@gmail.com

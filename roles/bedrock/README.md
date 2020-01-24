Role Name
=========

A brief description of the role goes here.

Requirements
------------

Install tested on Ubuntu18.04

Role Variables
--------------

../defaults/main.yml

bedrock_clone_dir: {{ ansible_env.HOME }}/bedrock"
bedrock_src: https://github.com/Expensify/Bedrock.git

Dependencies
------------

https://bedrockdb.com/
See tasks/install_dependencies.yml



Example Playbook
----------------

- hosts: "{{ target_host }}"
  remote_user: "{{ target_user }}"
  roles:
    - name: bedrock



License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

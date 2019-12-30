Role Name
=========

Tasks to run on a host post nagio4.4.5 install on Ubuntu16.04. See nagios_install_server.yml which uses the networklore role to compile and install Nagios4.4.5, Plugins2.3.1, and NrepServer3.2.1

Requirements
------------

Install Nagios4.4.5 using the nagios_install_server.yml and the networklore role provided by Ansible Galaxy.

Role Variables
--------------

The base role in tasks/main.yml installs contacts.cfg which uses the var 'nagios_admin_email' in /vars/main.yml.


Dependencies
------------

First: > ansible-playbook nagios_install_requirements.yml -e "target_host=some_host"
Second: > ansible-playbook install_nagios_server.yml -e "target_host=some_host"


Example Playbook
----------------

> ansible_playbook nagios_base_nagios_role.yml -e "target_host=some_host"

- hosts: "{{ target_host }}"
  remote_user: "{{ target_user }}"
  roles:
    - role: nagios

  [[ main.yml ]]
  1. Runs the following

    [[ update_commands.yml ]]
  
    1. Adds the check_nrpe command to the commands.cfg

    [[ update_contact.yml ]]

    1. Removes default email
    2. Remove previous email if not default.
    3. Adds the email that is in roles/nagios/vars/mail 'nagios_admin_email'

    [[ update_nagios_cfg.yml ]]
   
    1. Add the /servers/ folder to the nagios.cfg so that server cfgs can live there.

    NOTE: Role DOES NOT reset nagios.

    [[ TO DO ]]
     * Add a controller to restart nagios after changes have been informed.
     * Include all the tasks begining with 'nagios_' into main.yml playbook.  
Tasks
-----

[[ nagios_add_nrpe_checks.yml]]

> ansible-playbooks roles/nagios/tasks/nagios_add_nrpe_checks.yml -e "target_host=some_host disk_check=/dev/sda1 http_port=8080"

Vars:
  - disk_check : Location of disk to check on host.
  - http_port : port to monitor, defaults to 80 if nothing entered.

1. Uploads the checks to the monitored clients.  
2. Resets the client so changes take effect.


[[ nagios_install_linux-nrpe-agent.yml ]]

> ansible-playbook roles/nagios/tasks/nagios_intall_linux-nrpe-agent.yml -e "target_host=some_host server_ip=192.168.1.2"

Vars:
  - server_ip adds the server ip to /etc/xinit.d/nrpe config during installation.

1. Downloads the linux-nrpe-agent
2. Creates the download dir if it does not exist
3. Unpacks linux-nrpe-agent.tar
4.  runs ./fullinstall -n -i server_ip



[[ nagios_proxy_monitor.yml ]]

> no ansible_playbook playbook incomplete.

1. Downloads a bash script for checking http on a proxy.
2. Updates the check on the host.



[[ nagios_tuning_server.yml ]]

> ansible-playbook nagios_tuning_server.yml -e "target_host=some_host"

Vars:
  - file containing or updating the sysctl settings.

1. Copies sysctl setting from files to sysctl.d folder
2. Reloads sysctl so setting are applied
3. Adjust the file limits for the nagios user
4. Reloads the systctl settings.

[ TO DO ]
 * Do we really need to reset sysctl two times?


[[ nagios_upload_monitoring_config.yml ]]

> ansible-playbook role/nagios/task/nagios_upload_monitoring_config.yml -e "target_host=some_host" --tages="dev|stage|prod"

Tags:
  - dev : vagrant environment
  - stage : aws staging environment
  - prod : production environment

Vars: 
  - files containing the server side Nagios configs with the check_nrpe commands.

1. Creates the folder servers for the configs
2. Uploads the configs based on tag 
3. Reload nagios so that new configs are applied

[ TO DO ]
 * template the nagios server side configs.

License
-------

BSD

Author Information
-----------------

Kevin Litzenberg-


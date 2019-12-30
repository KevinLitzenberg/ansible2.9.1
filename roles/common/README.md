Role Common
=========

System Admin tasks

Requirements
------------

None

Role Variables
--------------

None

Dependencies
------------

None

Tasks
----------------
 [[ baseline_host.yml ]]
> ansible-playbook role/common/tasks/baseline_host.yml -e "target_host=some_host"

1. Updates hostname to match inventory name
2. Updates ect/hosts with local ip:hostname combo. Removing any previous entires if they exist.
3. Updates apt cache and apt packages


[[  iptables_configuration.yml ]]
> ansible-playbook roles/common/tasks/iptables_configuration.yml -e "target_host=aws_lb_nginx01 iptables_file=iptables_{frontend|backend}" [NO '.sh' or ''.conf']

Example: 
> ansible-playbook roles/common/tasks/iptables_configuration.yml -e "target_host=aws_ws_nagios01 iptables_file=iptables_backend" ( DO NOT ADD '.sh ot .conf' this way we upload both)

Just upload new rules for testing run just the iptables_{group}.sh transfer
> ansible-playbook roles/common/tasks/iptables_configuration.yml --tags "iptables_shell" -e "target_host=aws_ws_nginx01 iptables_file=iptables_backend"

* playbook forces naming of the file in the extra args to ensure you are really doing what you think you are doing.
1.  copies iptables_{name}.sh to /etc/nework/iptables{name}.sh
- The iptables_{name}.sh file is the key to creating and testing ip tables.
            a. Update the “backdoor” to some ip you have access too.
   	b. Adjust the iptables_{name}.sh file
	c. For testing purpose run just the iptables_{name}.sh
            > ansible-playbook iptables_copy_to_host.yml --tags "iptables_shell" -e "target_host=some_host(s) iptables_file=iptables_backend"
2.  copies iptables_{name} files name to /etc/network/if_preup.d/iptables to table persistence.
   WARNING: test your iptables, or you could be locked out on next reboot or network reset.
3. copies iptables_{name}.conf to /etc/iptables{name}.conf
4. copies iptables.conf to /etc/iptables.conf.  The file iptables.conf is a wide open firewall. This is the [default] action a wide open firewall.  It is a requirement to log into the host(s) and run iptables_{name}.sh to apply the iptables.  However, if you reboot or reset your network the iptables will be activated.  DO NOT RUN THIS playbook unless you are ready to test or be ready to manually change the /etc/network/if-pre-up.d/iptables file to the following.

#!/bin/bash
/sbin/iptables-restore < /etc/iptables.conf

5. Manual activation is required in an effort to force testing your firewall rules throughly prior to automation.

Useful commands for testing ip tables.
 * Safe testing:
     > sudo iptables -S
     > sudo iptables-apply /etc/iptables_{frontend|backend}.conf (applies a timer)

 * Watch iptable stats:
     > watch 'iptables -nvL'

  * Brute force testing for those who don’t mind losing machines.
      > iptables-restore < iptables_{some_test_config}.conf

  * Bring me back to sanity… Please.
      > iptables-restore < iptables.conf
      > /etc/network/if-pre.d/iptables
      > systemctl restart networking

TO DO : 
- It’s a bit clunky creating the iptables_{frontend|backend}.sh file. Running the playbook then logging in to run the script, crossing fingers, and testing the rules… Should combine a few tasks by creating tags for switch points.
- Automagically create the iptables_{frontend|backend}.conf by running the iptables_{frontend|backend}.sh and placing the output in /etc/iptables_{frontend|backend}.conf which will reduce task load in ansible.
-Add tagging to the playbook so there’s choice between updating /etc/network/if-pre.d/iptables pointing at iptables_{frontend|backend}.conf OR [default] to point to iptables.conf.
-Currently task ‘Add iptables file to network’ and task ‘Copy iptables to network interface’ do not have impedance.  Place a check a ‘when’ check before running the task. 
-Templatize ip tables: https://github.com/ansible/ansible-examples/blob/master/lamp_haproxy/roles/common/templates/iptables.j2


[[ sshd_backend_management.yml ]]

> ansible-playbook roles/common/tasks/sshd_backend_management.yml -e "target_host=some_host"

1. Removes sshd_config LISTEN 0.0.0.0
2. Adds sshd_config LISTEN {{ local_ip }}
3. Restartes sshd in check mode (so you don't happen to loose conectivty)

[[ sshd_frontend_management.yml ]]

> ansible-playbook roles/common/tasks/sshd_frontend_management.yml -e "target_host=some_host"

TIP: Run after running user_management.yml

Vars:
  - You must provide your own private key and point to that dir.

1. Ensures that the users .ssh directory exists, creates if not.
2. Installs a private key from directory on local


[[user_management.yml]] 

> ansible-playbook roles/common/tasks/user_management.yml -e "target_host=some_host"
 
Step1: Update the variable to user name
Step2: Update the authorized_keys location
1. Adds user shell and adds to sudo
2. Uploads an authorized_keys file to user ~/.ssh/
3. Allows user passwordless sudo
4. Adds to sudo group

[TO DO] 
- pass user in as an -e extra-vars.



License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

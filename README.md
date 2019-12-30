# ansible2.9.1

All playbooks and roles written for ansible2.9.1 utilizing a python3.7 virtualenvironment.

The first step to to create and activate your virtual environment, which for the purposes of this repo the venv has been ignored.


SET UP THE ENVIRONMENT:

Dependencies:
Python3.7.5

1. Create the virtual environment
> python3.7 -m venv venv
> source venv/bin/activate

2. Install ansible via pip3 with-in the virutal environment
> pip install -r requirements.txt

3. Update the ansible.cfg to reflect any local chnages that may need updating.I.E. /home/your_user_name

4. Set up inventory/inventory.json.  
  * inventory used the .ini style for hosts, and host_groups
  * inventory depends on a properly configured .ssh/config such as:
      Host hostname/ip_address
      user host_user_name
      Port port_numbe
      IdentityFile path_to_private_key
      
  * inventory.json uses hostvar 'target_user' to plug into playbooks.

5. Install the ansible-galaxy nginx role.
> ansible-galaxy install nginxinc.nginx
See requirements.yml for speific version install.  
> - nginxinc.nginx, 0.12.0

Playbooks Nginx

[[ nginx_ws_deploy.yml ]] 

> ansible-playbook nginx_ws_deploy.yml -e "target_host=some_host"
1. deploys a basic nginx webserver utilzing the nginx_demo website.  The base install is a single webserver in /usr/share/nginx/html/demo-index.html


[[ nginx_ws_backend_deploy.yml ]]

> ansible-playbook nginx_ws_backend_deploy.yml -e "target_host=some_host"

Vars: 
  - Uses the variable "target_lb_port" roles/nginxinc/vars/main.yml

1. Deploys the backends for the lbs.


[[ nginx_lb_frontend_deploy.yml ]]

> ansible-playbook -vv nginx_lb_frontend_deploy.yml -e "target_host=some_host"

Vars: 
  - Uses the vars 'backend{1&2}_ip' role/nginxinc/vars/main.yml
	** These variables update ‘/etc/nginx/conf.d/upstreams.conf’ ‘rrbackend’ block, and also in ‘map’ portion of roles/nginxinc.nginx/templates/http/default.conf.j2

  - Uses the var 'lb_installation_port' sets lb LISTEN port facing public



1. Creates sticky cookie load balancer with stock opensource nginx.
2. Employes http v1.1 on the backend


[[ nginx_lb_frontend_sticky_deploy.yml ]] Making stock opensource NGINX sticky.

> ansible-playbook -vv nginx_lb_frontend_sticky_deploy.yml -e "target_hosts=some_host"

1. Will deply nginx a frontend lb with 2 backends.  Implements any of the standard opensource load balancing techniques, but primarily focuses on utilizing the ‘sticky’ cookie method without compiling nginx with sticky opensource mdule.  Yes this is ‘sticky’ cookie behavior with stock NGINX. Don't be silly just use haproxy next time.
> Credits for stock sticky cookie behavior: https://www.treitos.com/blog/
2. Employes http v1.1 on the backend
3. Added ‘proxy_http_version 1.1;’ to frontend to take advantage of consistent keepalive values. 

Then update the inventory/inventory.json hosts file to reflect that same id for each end.  It's gross, see [TO DO] will be updated in future releases.
[prod_nginx]
prod_nginx01 target_user=ubuntu sticky_backend_id=backend=backend1
prod_nginx02 target_user=ubuntu sticky_backend_id=backend=backend2


[TO DO]
* update frontend with generic certs so NGINX doesn’t complain on reload.
		[emerg] 24606#24606: cannot load certificate "/etc/ssl/certs/proxy_default.crt":.......
...
...
... 
* change the backend servers from being hardcoded vars in main.yml to use hostvars instead.
* Update the map: directive in ‘roles/nginxinc.nginx/templates/http/default.conf.j2’ to use .yml that can be over ridden in the role.

[[  nginx_system_tuning.yml ]]

> ansible-playbook nginx_system_tuning.yml -e "target_host=some_host" 

Vars:
  - hardcoded sysctl settings.  Point to your own hardcoded sysctl settings
  - Uses role/nginxinc/vars/main.yml 'lb_high_traffic_port' set to your own value.

1. Updates the ngnix Unit file.
2. Updates the /etc/security/limits.conf for the ngninx
3. Reloads sysctl to make changes effective.
4. Imports sysctl settings to /etc/sysctl.d/{file_name}
5. Restarts syscl so that file is picked up and setting take effect.
6. Adjusts NGINX frontend_lb to listen on ports 60000-65000 
7. Finally will STOP and START nginx. So that NGINX can get new settings.


Playbooks Nagios:

[[nagios_install_requirements.yml ]]

> ansible-playbook nagios_install_requirements.yml -e "target_host=some_host"

Prepares the server to install nagios4.4.5 on Ubuntu16.04 using python3.5 and the augmented networklore role to install nagios 
1. Installs python3-pip via apt
2. Symbolically links pip and pip2 in /usr/bin
3. Install passlib using pip3, which nagios uses to access htpasswd and update password.

[[ TO DO ]]

* Include this as a set of tasks in the main.yml playbooks. 
  For example: If family==Ubuntu16.04 include these tasks.


[[ nagios_install_server.yml ]] 
***(for python3.5 and Ubuntu16.04 support run nagios_install_requirements.yml first.***

> ansible-playbook nagios_install_server.yml -e "target_host=some_host"

Vars:
  - Update the defaults/main.yml 'pass' variable to some secure password.

1. Uses the role networklore.nagios. Applied many updates to this role for ubuntu16.04 see notes.
2. Updated role to downloads the latest Nagios4.4.5

Notes on updating the networklore.nagios role.
This role needs lots of attention to get this working on Ubuntu16.04.  

Needed to update this role to accommodate for the following.
	- Ubuntu16.04 had to update php5-ng to php-ng(php7) when installing apache
	- Updated libradius-client-dev-ng to libfreeradius-client-dev

https://ubuntu.pkgs.org/16.04/ubuntu-universe-i386/libfreeradius-client-dev_1.1.6-7_i386.deb.html


 	-Updated: /tasks/main.yml to included
		- name: Activate Nagios site on Ubuntu 16.04
  		  file: src=/etc/apache2/conf-available/nagios.conf dest=/etc/apache2/conf-enabled/nagios.conf state=link owner=root group=root
  		 notify: restart apache
  		when: ansible_distribution == 'Ubuntu' and ansible_distribution_version == '16.04'

		- name: Enable CGI
  		  apache2_module:
    		    name: cgi
      		    state: present
  		 notify: restart apache
  		 when: ansible_distribution == 'Ubuntu' and ansible_distribution_version == '16.04'

	- Also added in the nrpe.3.2.1 plugin to the buld.
		Defaults/main.yml
		# Download and compile the nrpe server plugin
		nrpe_pluginurl: https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.2.1/nrpe-3.2.1.tar.gz

		nrpe_pluginsrc: nrpe-3.2.1
		Added to tasks/main.yml
		include_task nrpe_installplugin (server only)


[TO DO]
* Compile the server side with ssl encryption (see digital ocean)  The linux-nrpe-agent has ssl installed by default. 
	> ./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu
* Fork and Update networklore role to include 16.04.

[[ nagios_install_agent.yml ]]

> ansible-playbook nagios_install_agent.yml -e "target_host=some_host"

1. Downloads the agent
2. Complies the agent
3. Test this playbook, works in testing but opted to install via nagios_linux_agent method.
[TO DO]

[[ ]]

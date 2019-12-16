# ansible2.9.1

All playbooks and roles written for ansible2.9.1 utilizing a python3.7 virtualenvironment.

The first step to to create and activate your virtual environment, which for the purposes of this repo the venv has been ignored.


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

Playbooks

[[ nginx_ws_deploy.yml ]] 
    deploys a basic nginx webserver utilzing the nginx_demo website.  The base install is a single webserver in /usr/share/nginx/html/demo-index.html

   * to run the playbook speicfy the hostname ustilizing the --extra-vars modifier.
   > ansible-playbook nginx_ws_deploy.yml -e "target_host=some_host_to_provision"

[[ nginx_ws_backend_deploy.yml ]] 
    deploy the backends for the lbs.  Set the variable "target_lb_port in the inventory or using the -e (--extra-vars) modifier for each backend that is needed.  
Example inventory:
> aws_ws_nginx01 target_user=ubuntu target_lb_port=8081

Run the playbook on the server.
> ansible-playbook nginx_ws_backend_deploy.yml -e "target_host=some_host_to_provision"

[[ nginx_lb_frontend_deploy.yml ]]
1. This will create standard load balancer with stock opensource load balancing algorithms.
2. See #2 for nginx_lb_frontend_sticky_deploy.yml
3. Employes http v1.1 on the backend

Run the playbook to create the frontend lb.
> ansible-playbook -vv nginx_lb_frontend_deploy.yml -e "some_host_to_provision"

[[ nginx_lb_frontend_sticky_deploy.yml ]] Making stock opensource NGINX sticky.
1. Will deply nginx a frontend lb with 2 backends.  Implements any of the standard opensource load balancing techniques, but primarily focuses on utilizing the ‘sticky’ cookie method without compiling nginx with sticky opensource mdule.  Yes this is ‘sticky’ cookie behavior with stock NGINX!!!  Next time just use haproxy!!
> Credits for stock sticky cookie behavior: https://www.treitos.com/blog/
2. Before running update the hard coded variable ip addresses for the backends in  ‘roles/nginxinc.nginx/vars/main.yml’  these variables update ‘/etc/nginx/conf.d/upstreams.conf’ ‘rrbackend’ block, and also in ‘map’ portion of roles/nginxinc.nginx/templates/http/default.conf.j2
Currently set as.
	backend1_ip: 192.168.1.2
            backend2_ip: 192.168.1.3 
3. Employes http v1.1 on the backend
4. Added ‘proxy_http_version 1.1;’ to frontend to take advantage of consistent keepalive values. 

5. Before production it would be a good idea to update the 'backend1' and 'backend2' sticky cookie names to something unique like UUID of md5 hash.  That would mean updating

map $cookie_backend $sticky_backend {
    default bad_gateway;
    backend1 172.31.36.235;
    backend2 172.31.35.77;
}

Then update the inventory/inventory.json hosts file to reflect that same id for each end.  It's gross, see [TO DO] will be updated in future releases.
[prod_nginx]
prod_nginx01 target_user=ubuntu target_lb_ports=80 sticky_backend_id=backend=backend1
prod_nginx02 target_user=ubuntu target_lb_ports=80 sticky_backend_id=backend=backend2


[TO DO]
* update frontend with generic certs so NGINX doesn’t complain on reload.
		[emerg] 24606#24606: cannot load certificate "/etc/ssl/certs/proxy_default.crt": BIO_new_file() failed (SSL: error:02001002:system library:fopen:No such file or directory:fopen('/etc/ssl/certs/proxy_default.crt','r') error:2006D080:BIO routines:BIO_new_file:no such file) currently commented out. 
* change the backend servers from being hardcoded local ips to use hostvars instead.
* Update the map: directive in ‘roles/nginxinc.nginx/templates/http/default.conf.j2’ to use .yml that can be over ridden in the role.
* integrate ‘nginx_lb_frontend_system_deploy.yml’ so that it gets trigged after the nginx role installs the unit file.  Requires a full nginx stop/start when updating sysctl values to accommodate open files.

[[ nginx_lb_fontend_system_deploy and nginx_lb_backend_system_deploy.yml ]]
1. Both of these files update the nignix Unit file.  Each have diffent values since each employ a frontend at atleast 2X the connections of the backend.
2. Updates the /etc/security/limits.conf for the ngninx user then reloads sysctl to make changes effective.
3. Finally will STOP and START nginx.  Please be aware if you are running production traffic.

[ TO DO ]
* integrate with nginx role.  Run only when nginx -t errors with 'too many files open.'
* change values to variables and combine the two files into one universal file. 



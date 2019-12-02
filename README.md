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


Playbooks

nginx_ws_deploy.yml deploys a basic nginx webserver utilzing the nginx_demo website.  The base install is a single webserver in /usr/share/nginx/html/demo-index.html

   * to run the playbook speicfy the hostname ustilizing the --extra-vars modifier.
   > ansible-playbook nginx_ws_deploy.yml --extra-vars "target_host=some_host_to_provision"


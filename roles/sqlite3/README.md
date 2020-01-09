Role Name
=========

Installation, configuration, maintance, and testing of the sqlite3.3.1.  

Requirements
------------

Tested on Ubuntu16.04 and Ubuntu18.04



Role Variables
--------------
download_sqlite_dir: the directory where sqlite3 will be downloaded and installed
sqlite3_url: the version of sqlite3.x.x
sqlite3_src: the folder location of the sqlite3 install

download_sqlitetools_dir: the directory where sqlite_tools will be downloaded and installed
sqlite_tools_url: the version of sqlite_tools3.x.x
sqlite_tools_src: the folder location fo the sqlite_tools install

Dependencies
------------

sqlite3.x.x requires the installation of build-esstails.  These requirements are installed via install_sqlite3_dependencies.yml and will run before the installation of the install_sqlite3.yml

sqlite_tools requires the installation of install 32bit-libraries and unzip.  These packages are installed via install_sqlite_tools_dependencies.yml and will run before the installation of install_sqlite_tools.yml 

Example Playbook
----------------

> ansible-playbook sqlite_base_install.yml -e "target_host=some_host"

---
- hosts: "{{ target_host }}"
  remote_user: "{{ target_user }}"
  roles:
    - role: sqlite3

License
-------

BSD

Author Information
------------------
kevin.litzenberg@gmail.com

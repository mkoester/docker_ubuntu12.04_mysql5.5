docker_ubuntu12.04_mysql5.5
===============================

This image uses

- ubuntu 12.04
- mysql 5.5

and exposes this port

- 3306

users and passwords:

- root with pw root
- dbuser with pw password

Running the container
---------------------

This enables you to run this container as follows:

    sudo docker run -d -p <local_port>:3306 --name <container_name> -t <name_of_this_image>:<tag>

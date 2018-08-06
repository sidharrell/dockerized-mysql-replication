**Dockerized-Mysql-Replication**  
  
To generate your own selfsigned cert, you will need to run the cert_regen.sh
bash script. It will replace the file roles/haproxy/files/selfsigned.pem.
You will need to copy the generated certs/myCA.pem file, and tell your
browser that it is a trusted CA.  
Edit the host_vars/mysql1 and host_vars/mysql2 to make the ip addresses
match those of the machines you are deploying to.  
Deploy with  
`ansible-playbook -i hosts replicated-docker-mysql.yml
`  

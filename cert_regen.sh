#!/bin/bash
mkdir certs
openssl genrsa -des3 -out certs/myCA.key 2048
echo "These questions relate to the CA you are creating."
openssl req -x509 -new -nodes -key certs/myCA.key -sha256 -days 1825 -out certs/myCA.pem
openssl genrsa -out selfsigned.key 2048
echo "These questions relate to the CSR generation."
openssl req -new -key selfsigned.key -out selfsigned.csr
cat <<EOF > certs/selfsigned.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
EOF
read -p "What is the hostname you want to use for the first host? " -r
echo $REPLY >> certs/selfsigned.ext
read -p "What is the hostname you want to use for the second host? " -r
echo $REPLY >> certs/selfsigned.ext
openssl x509 -req -in certs/selfsigned.csr -CA certs/myCA.pem -CAkey certs/myCA.key -CAcreateserial -out certs/selfsigned.crt -days 1825 -sha256 -extfile certs/selfsigned.ext
cat certs/selfsigned.key certs/selfsigned.crt > certs/selfsigned.pem
cp certs/selfsigned.pem roles/haproxy/files/selfsigned.pem

#!/bin/bash
mkdir certs
echo "These questions relate to the generation of the key."
echo "You must enter a passphrase, you cannot skip, you cannot escape."
echo "You have been warned!"
echo
openssl genrsa -des3 -out certs/myCA.key 2048
echo
echo "These questions relate to the CA you are creating."
echo
openssl req -x509 -new -nodes -key certs/myCA.key -sha256 -days 1825 -out certs/myCA.pem
openssl genrsa -out certs/selfsigned.key 2048
echo
echo "These questions relate to the CSR generation."
echo
openssl req -new -key certs/selfsigned.key -out certs/selfsigned.csr
cat <<EOF > certs/selfsigned.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
EOF
echo
read -p "What is the hostname you want to use for the first host? " -r
echo "DNS.1 = $REPLY" >> certs/selfsigned.ext
read -p "What is the hostname you want to use for the second host? " -r
echo "DNS.2 = $REPLY" >> certs/selfsigned.ext
echo
echo "Signing"
echo
openssl x509 -req -in certs/selfsigned.csr -CA certs/myCA.pem -CAkey certs/myCA.key -CAcreateserial -out certs/selfsigned.crt -days 1825 -sha256 -extfile certs/selfsigned.ext
cat certs/selfsigned.key certs/selfsigned.crt > certs/selfsigned.pem
cp certs/selfsigned.pem roles/haproxy/files/selfsigned.pem

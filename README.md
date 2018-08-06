dockerized-haproxy
You will need to generate your own CA, a CSR, and sign your CSR with your CA.

On some linux machine, outside of this repo, run the following.

Note that you need to change the docker host hostnames that the cert is good for to match yours. Also there is a space in front of EOF that needs to be deleted for the heredoc to work. I couldn't delete it here and preserve the pretty output.
<pre>
openssl genrsa -des3 -out myCA.key 2048

openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem

openssl genrsa -out selfsigned.key 2048

openssl req -new -key selfsigned.key -out selfsigned.csr

cat << EOF > selfsigned.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = dockerhost1
DNS.2 = dockerhost2
EOF

openssl x509 -req -in selfsigned.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out selfsigned.crt -days 1825 -sha256 -extfile selfsigned.ext

cat selfsigned.key selfsigned.crt > selfsigned.pem</pre>
You will now need to copy the selfsigned cert back into your copy of the repo, and cat out the myCA.pem. You need to tell Chrome to trust your certs by importing myCA.pem into the Keychain app, and tell Firefox by importing myCA.pem directly into Firefox trusted CAs. At least on a Mac.
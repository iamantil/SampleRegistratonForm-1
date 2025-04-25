#!/bin/sh
echo "Installing JDK"
apk update
apk add --no-cache openjdk11
rm -f /root/.hvclient/keystore.jks
openssl genrsa 2048 > /root/.hvclient/key.pem
/hvclient -trustchain > /root/.hvclient/ca_chain.pem
/hvclient -privatekey /root/.hvclient/key.pem -commonname devops.atlasqa.co.uk -csrout > /root/.hvclient/csr.pem
/hvclient -commonname pki.atlasqa.co.uk -dnsnames=pki.atlasqa.co.uk -sighash=SHA-256  -csr /root/.hvclient/csr.pem > /root/.hvclient/cert.pem
openssl pkcs12 -export \
  -in /root/.hvclient/cert.pem \
  -inkey /root/.hvclient/key.pem \
  -certfile /root/.hvclient/ca_chain.pem \
  -out /root/.hvclient/keystore.p12 \
  -passout "pass:changeit"
keytool -importkeystore \
  -srckeystore /root/.hvclient/keystore.p12 \
  -srcstoretype PKCS12 \
  -srcstorepass changeit \
  -deststorepass changeit \
  -destkeystore /root/.hvclient/keystore.jks

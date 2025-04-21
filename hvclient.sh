#!/bin/sh
openssl genrsa 2048 > /root/.hvclient/key.pem
/hvclient -trustchain > /root/.hvclient/ca_chain.pem
/hvclient -privatekey /root/.hvclient/key.pem -commonname pki.atlasqa.co.uk -csrout > /root/.hvclient/csr.pem
/hvclient -commonname pki.atlasqa.co.uk -dnsnames=pki.atlasqa.co.uk -sighash=SHA-256  -csr /root/.hvclient/csr.pem > /root/.hvclient/cert.pem
openssl pkcs12 -export \
  -in /root/.hvclient/cert.pem \
  -inkey /root/.hvclient/key.pem \
  -certfile /root/.hvclient/ca_chain.pem \
  -out /root/.hvclient/keystore.p12 \
  -passout "changeit"

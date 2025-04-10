#!/bin/sh
openssl genrsa 2048 > /root/.hvclient/test.key
/hvclient -trustchain > /root/.hvclient/ca_chain.pem
/hvclient -privatekey /root/.hvclient/test.key -commonname pki.atlasqa.co.uk -csrout > /root/.hvclient/csr.pem
/hvclient -commonname pki.atlasqa.co.uk -dnsnames=pki.atlasqa.co.uk -sighash=SHA-256  -csr /root/.hvclient/csr.pem > /root/.hvclient/tls.crt
#tail -f /dev/null

#!/bin/sh
# -*- coding: utf-8 -*-

service_ip=${1:-10.3.0.1}
output_file=/tmp/certs.yml
sed -i '/^IP\.2.*/d' openssl.cnf
echo "IP.2 = $service_ip" >> openssl.cnf
 
gen_cert() {
    openssl genrsa -out ca-key.pem 2048
    openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"

    openssl genrsa -out apiserver-key.pem 2048
    openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.cnf
    openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile openssl.cnf

    openssl genrsa -out worker-key.pem 2048
    openssl req -new -key worker-key.pem -out worker.csr -subj "/CN=kube-worker" -config openssl.cnf
    openssl x509 -req -in worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out worker.pem -days 365 -extensions v3_req -extfile openssl.cnf

    openssl genrsa -out admin-key.pem 2048
    openssl req -new -key admin-key.pem -out admin.csr -subj "/CN=kube-admin" -config openssl.cnf
    openssl x509 -req -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -days 365 -extensions v3_req -extfile openssl.cnf
}

enc_cert() {
    for i in `ls *.pem`
    do
        ansible-vault encrypt $i
    done
}

gen_var() {
    echo '---' > $output_file
    for i in `ls *.pem`
    do
        echo "$i: |" >> $output_file
        ansible-vault view $i | sed 's/^/  /' >> $output_file
    done
}

help() {
    echo "./gencert.sh gen_cert|gen_var"
}

case $1 in
    gen_cert)
        gen_cert
        ;;
    enc_cert)
        enc_cert
        ;;
    gen_var)
        gen_var
        ;;
    *)
        help
        ;;
esac

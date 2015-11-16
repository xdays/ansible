# Kubernetes

this role is used to create a kubernetes cluster

# config

first, you need to prepare the certificates, if you need to create a new cluster

    cd files
    ./gencert.sh gen_cert # to generate certificate
    ./gencert.sh enc_cert # to encrypt certificate

then, you need to prepare your inventory file, example

<pre>
[etcd]
10.50.0.79

[master]
10.50.0.79

[agent]
10.50.0.80
10.50.0.81
</pre>

# deploy

    ansible-playbook -i ~/inventory -u ever -s playbooks/truth.yml -e role=kubernetes -e target=all

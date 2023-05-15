#!/usr/bin/env bash

BASE_DIR="/tmp"
LIC="/tmp/emqx/etc/emqx.lic"

# Install necessary dependencies
sudo apt-get -y update
sudo apt-get -y install zip

# system config
sudo sysctl -w fs.file-max=2097152
sudo sysctl -w fs.nr_open=2097152
echo 2097152 | sudo tee /proc/sys/fs/nr_open
sudo sh -c "ulimit -n 1048576"

echo 'fs.file-max = 1048576' | sudo tee -a /etc/sysctl.conf
echo 'DefaultLimitNOFILE=1048576' | sudo tee -a /etc/systemd/system.conf

sudo tee -a /etc/security/limits.conf << EOF
root      soft   nofile      1048576
root      hard   nofile      1048576
azureuser    soft   nofile      1048576
azureuser    hard   nofile      1048576
EOF

# tcp config
sudo sysctl -w net.core.somaxconn=32768
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=16384
sudo sysctl -w net.core.netdev_max_backlog=16384

sudo sysctl -w net.ipv4.ip_local_port_range='1024 65535'

sudo sysctl -w net.core.rmem_default=262144
sudo sysctl -w net.core.wmem_default=262144
sudo sysctl -w net.core.rmem_max=16777216
sudo sysctl -w net.core.wmem_max=16777216
sudo sysctl -w net.core.optmem_max=16777216

sudo sysctl -w net.ipv4.tcp_rmem='1024 4096 16777216'
sudo sysctl -w net.ipv4.tcp_wmem='1024 4096 16777216'

sudo modprobe ip_conntrack
sudo sysctl -w net.nf_conntrack_max=1000000
sudo sysctl -w net.netfilter.nf_conntrack_max=1000000
sudo sysctl -w net.netfilter.nf_conntrack_tcp_timeout_time_wait=30
sudo sysctl -w net.ipv4.tcp_max_tw_buckets=1048576
sudo sysctl -w net.ipv4.tcp_fin_timeout=15

# install emqx
sudo unzip /tmp/emqx.zip -d $BASE_DIR
sudo chown -R azureuser:azureuser $BASE_DIR/emqx
sudo rm /tmp/emqx.zip

sudo sed -i 's/sysmon.large_heap = 8MB/sysmon.large_heap = 64MB/g' $BASE_DIR/emqx/etc/sys_mon.conf
# emqx config
sudo sed -i 's/## node.process_limit = 2097152/node.process_limit = 2097152/g' $BASE_DIR/emqx/etc/emqx.conf
sudo sed -i 's/## node.max_ports = 1048576/node.max_ports = 1048576/g' $BASE_DIR/emqx/etc/emqx.conf
sudo sed -i 's/node.name = emqx@127.0.0.1/node.name = emqx@${local_ip}/g' $BASE_DIR/emqx/etc/emqx.conf
sudo sed -i 's/^node\.cookie.*/node.cookie = ${cookie}/' $BASE_DIR/emqx/etc/emqx.conf
# listener config
sudo sed -i 's/listener.tcp.external.acceptors = 8/listener.tcp.external.acceptors = 64/g' $BASE_DIR/emqx/etc/listeners.conf
sudo sed -i 's/listener.tcp.external.max_conn_rate = 1000/listener.tcp.external.max_conn_rate = 10000/g' $BASE_DIR/emqx/etc/listeners.conf
sudo sed -i 's/listener.ssl.external.keyfile = etc\/certs\/key.pem/listener.ssl.external.keyfile = etc\/certs\/emqx.key/g' $BASE_DIR/emqx/etc/listeners.conf
sudo sed -i 's/listener.ssl.external.certfile = etc\/certs\/cert.pem/listener.ssl.external.certfile = etc\/certs\/emqx.pem/g' $BASE_DIR/emqx/etc/listeners.conf
sudo sed -i 's/listener.ssl.external.cacertfile = etc\/certs\/cacert.pem/listener.ssl.external.cacertfile = etc\/certs\/emqx_ca.pem/g' $BASE_DIR/emqx/etc/listeners.conf
sudo sed -i 's/## listener.ssl.external.gc_after_handshake = false/listener.ssl.external.gc_after_handshake = true/g' $BASE_DIR/emqx/etc/listeners.conf
sudo sed -i 's/## listener.ssl.external.hibernate_after = 5s/listener.ssl.external.hibernate_after = 5s/g' $BASE_DIR/emqx/etc/listeners.conf

# emqx cluster
sudo sed -i 's/^cluster\.discovery.*/cluster.discovery = static/' $BASE_DIR/emqx/etc/cluster.conf
sudo sed -i 's/^## cluster\.static\.seeds.*/cluster.static.seeds = ${all_nodes}/' $BASE_DIR/emqx/etc/cluster.conf

# if enable two way ssl
if [ $enable_ssl_two_way = true ]; then
sudo sed -i 's/## listener.ssl.external.verify = verify_peer/listener.ssl.external.verify = verify_peer/g' $BASE_DIR/emqx/etc/listeners.conf
sudo sed -i 's/## listener.ssl.external.fail_if_no_peer_cert = true/listener.ssl.external.fail_if_no_peer_cert = true/g' $BASE_DIR/emqx/etc/listeners.conf
fi

# create license file
if [ -n "${emqx_lic}" ]; then
sudo cat > $LIC<<EOF
${emqx_lic}
EOF
fi

# generate certificate files
#
echo "${emqx_ca}" | sudo tee $BASE_DIR/emqx/etc/certs/emqx_ca.pem
echo "${emqx_key}" | sudo tee $BASE_DIR/emqx/etc/certs/emqx.key
echo "${emqx_cert}" | sudo tee $BASE_DIR/emqx/etc/certs/emqx.pem

#apt-get -y install haproxy 
apk add haproxy
mkdir -p /usr/local/etc/haproxy/

cat <<EOF > /usr/local/etc/haproxy/haproxy.cfg
global
    maxconn  20000
    log      127.0.0.1 local0
    user     haproxy
    chroot   /usr/share/haproxy
    pidfile  /run/haproxy.pid
    daemon
    stats socket /run/haproxy.sock mode 666
    stats timeout 60s
frontend main
    bind :5000
    mode               http
    log                global
    option             httplog
    option             dontlognull
    option             http_proxy
    option forwardfor  except 127.0.0.0/8
    timeout            client  30s
    default_backend    app
frontend stats
    bind     *:8404
    mode     http
    stats    enable
    stats    uri /stats
    stats    refresh 10s
    timeout  client  30s
backend app
    mode        http
    balance     roundrobin
    timeout     connect 5s
    timeout     server  30s
    timeout     queue   30s
    server  web1 web1:80 check
    server  web2 web2:80 check
    server  web3 web3:80 check
EOF

#systemctl restart haproxy 


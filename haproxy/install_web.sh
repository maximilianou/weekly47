#apt-get -y install nginx
apk add nginx
mkdir -p /var/www2

echo "Hi $1!!!" > /var/www2/index.html

cat <<EOF > /etc/nginx/nginx.conf
worker_process 1;
events {
  worker_connections 1024;
}
http {
  include mime.types;
  server {
    listen 80;
    server_name localhost;
    location / {
      root /var/www2;
      index index.html index.htm;
    }
  }
}
EOF

#systemctl restart nginx


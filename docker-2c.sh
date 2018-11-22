export DEBIAN_FRONTEND=noninteractive

apt-get remove docker docker-engine docker.io
apt-get update --assume-yes --force-yes
apt-get install apt-transport-https --assume-yes --force-yes
apt-get install ca-certificates --assume-yes --force-yes
apt-get install curl --assume-yes --force-yes
apt-get install software-properties-common --assume-yes --force-yes

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce --assume-yes --force-yes


ip link set dev eth1 up
ip add add 192.168.172.229/30 dev eth1
ip route add 192.168.168.0/21 via 192.168.172.230

mkdir -p ~/docker-nginx/html
cd ~/docker-nginx/html
touch index.html
truncate -s 0 index.html
echo "<!DOCTYPE html>
<html>
<head>
<title>Welcome on our page!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1> Welcome on our page!</h1>
<p>Irene Buffa [185151]<br>Daniele Mattedi [186778]</p>


<p><em>Thank you for visiting our page.</em></p>
</body>
" >> index.html
docker rm docker-nginx
docker run --name docker-nginx -p 80:80 -d -v ~/docker-nginx/html:/usr/share/nginx/html nginx


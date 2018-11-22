export DEBIAN_FRONTEND=noninteractive

apt-get update --assume-yes --force-yes
apt-get install apt-transport-https --assume-yes --force-yes
apt-get install ca-certificates --assume-yes --force-yes
apt-get install curl --assume-yes --force-yes
apt-get install software-properties-common --assume-yes --force-yes



ip link set dev eth1 up
ip add add 192.168.171.225/27 dev eth1
ip route add 192.168.168.0/21 via 192.168.171.254


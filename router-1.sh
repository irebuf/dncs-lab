export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
wget -O- https://apps3.cumulusnetworks.com/setup/cumulus-apps-deb.pubkey | apt-key add -
add-apt-repository "deb [arch=amd64] https://apps3.cumulusnetworks.com/repos/deb $(lsb_release -cs) roh-3"
apt-get update
apt-get install -y frr --assume-yes --force-yes
ip link set dev eth1 up
ip link add link eth1 name eth1.170 type vlan id 170
ip link add link eth1 name eth1.171 type vlan id 171
ip add add 192.168.170.254/24 dev eth1.170
ip add add 192.168.171.254/27 dev eth1.171

ip link set eth1.170 up
ip link set eth1.171 up
ip link set dev eth2 up
ip add add 192.168.173.1/30 dev eth2
ip link set eth2 up
sysctl net.ipv4.ip_forward=1

sed -i "s/\(zebra *= *\). */\1yes/" /etc/frr/daemons
sed -i "s/\(ospfd *= *\). */\1yes/" /etc/frr/daemons
service frr restart
vtysh
vtysh conf t
vtysh router ospf
vtysh redistribute connected
vtysh exit
vtysh interface eth2
vtysh ip ospf area 0.0.0.0
vtysh exit 
vtysh write



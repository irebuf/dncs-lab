# DNCS-LAB Assignment (2018-2019)

# Table of contents
- [ Who-we-are ](#Collaborators)
- [ Assignment ](#Assignment)
- [ Network Map ](#Map)
- [ Description of subnets ](#Subnets)
  - [ Subnet A ](#A)
    - [ Router 1 ](#r1-a)
    - [ Host 1-a ](#h1a-a)
    - [ Host 1-b ](#h1b-a)
    - [ Switch ](#s-a)
  - [ Subnet B ](#B)
    - [ Router 1 ](#r1-b)
    - [ Router 2 ](#r2-b)   
  - [ Subnet C ](#C)
    - [ Router 2 ](#r2-c)    
    - [ Host 2-c ](#h2c-c)
- [ How-to ](#how)
  - [ Requirements ](#Requirements)
  - [ Display the website ](#display)
  - [ Test the network ](#test)
    - [ Router 1 ](#r1-h)
    - [ Router 2 ](#r2-h)    
    - [ Switch ](#s-h)
    - [ Host 1-a ](#h1a-h)
    - [ Host 1-b ](#h1b-h)
    - [ Host 2-c ](#h2c-h)
<a name="Collaborators"></a>
# Who-we-are
- <Daniele Mattedi>, "Laurea in Ingegneria dell'Informazione e delle Comunicazioni", III year
- <Irene Buffa>, "Laurea in Ingegneria dell'Informazione e delle Comunicazioni", III year
<a name="Assignment"></a>
# Assigment
Based the `Vagrantfile` and the provisioning scripts available at:
https://github.com/dustnic/dncs-lab the candidate is required to design a functioning network where
any host configured and attached to `router-1` (through `switch` ) can browse a website hosted on
`host-2-c`.

The subnetting needs to be designed to accommodate the following requirement (no need to create
more hosts than the one described in the `vagrantfile`):
- Up to 130 hosts in the same subnet of `host-1-a`
- Up to 25 hosts in the same subnet of `host-1-b`
- Consume as few IP addresses as possible

<a name="Map"></a>
# Network Map
All the device of our Network can be reached using the broadcast address 192.168.168.000; the subnet mask is 255.255.248.000.
The Network can also be divide in three Subnetwork. 

  

        +---------------------------------------------------------------------------+
        |                                                                           |
        |                                                                           |
        |                                                                           |
        |                                                                           | eth0
    +------+                    +--------------+                            +---------------+
    |      |                    |              | 192.168.173.1              |               |
    |      |               eth0 |              | eth2                  eth2 |               |
    |  M   +--------------------+   router-1   +----------------------------+    router-2   |
    |  A   |                    |              |               192.168.173.2|               |
    |  N   |                    |              |                            |               |
    |  A   |                    +--------------+                            +---------------+
    |  G   |                   eth1.170 | eth1.171                                    | eth1
    |  E   |            192.168.170.254 | 192.168.171.254                             | 192.168.172.230
    |  M   |                            |                                             |
    |  E   |                            |                                             |
    |  N   |                            | eth1                                        |
    |  T   |               eth0 +---------------+                                     |
    |      +--------------------+               |                                     |
    |      |                    |    SWITCH     |                                     |
    |  V   |                    +---------------+                                     |
    |  A   |                eth2  |           | eth3                                  |
    |  G   |                      |           |                                       |
    |  R   |                      |           |                                       |
    |  A   |                      |           |                                       |
    |  N   |        192.168.170.1 |           | 192.168.171.225                       | 192.168.172.229
    |  T   |                 eth1 |           | eth1                                  | eth1
    |      |          +--------------+       +--------------+                    +------------+
    |      |          |              |       |              |                    |            |
    |      |          |              |       |              |                    |            |
    |      |     eth0 |   host-1-a   |       |   host-1-b   |                    |  host-2-c  |
    |      +----------+              |       |              |                    |            |
    |      |          |              |       |              |                    |            |
    |      |          +--------------+       +--------------+                    +------------+
    |      |                                        | eth0                             | eth0
    |      +----------------------------------------+                                  |
    |      |                                                                           |
    +------+                                                                           |
       |                                                                               |
       +-------------------------------------------------------------------------------+





In the first Subnet (A) there are `host-1-a`, `host-1-b`, `switch` and `router-1`; this net is split in two VLANs. The VLAN with the tag 170 links `router-1` with `host-1-a`; on the other side we have VLAN 171 that link `router-1` with `host-1-b`. <br>
The second Subnet (B) links the two routers of the topology eachother. <br>
In the last one (C),  the net links `router-2` with `host-2-c`.

<a name="Subnets"></a>
# Descriptions of  subnets
<a name="A"></a>
## Subnet A
Subnet A is  the part of the network in which we can find `router-1`, `switch`, `host-1-a` and `host-1-b`. The link has been split between the port eth1 of the router and the port eth1 of the switch in two VLANs, so the same physical link can be used to connect two different hosts through the switch.

The VLAN that links `router-1` to `host-1-a` has 24 bit reserved and only 8 bit dedicated to the hosts but its enough for our configuration. Even if there are 2^8 (256) different IP addresses, they can't all be used. 2 IPs are reserved: the first one (192.168.170.0) is for IP address space (it has all the last 8 bit at zero) and the last one (192.168.170.255) is the broadcast address (it has all the last 8 bits at value 1). We decided to use the first free IP address for the port eth1 of the host-1-a (192.168.170.1) and the last free for the port eth1.170 of the router (192.168.170.254).
The request for router-1 was to have 130 possible hosts to use. By using 7 bits for host we would have had only 128 different IPs addresses: they were not enought for our configuration. So we decided to use 8 bit (254 possibile hosts to use).

On the other side the VLAN that links `router-1` to `host-1-b` has 27 bits reserved for the Net and only 5 for the hosts. In this case at least 25 different IP addresses are needed and the 2^5 (32) addresses are enough for IP address space, broadcast address and hosts' addresses.
The first IP has to be used for IP address space and in our configuration is 192.168.171.224; the second to last adress is 192.168.171.225 and we decided to use it for port eth1 of `host-1-b`. We also assigned to eth1.171 of `router-1` address 192.168.171.254  and lastly we chose to use the last IP 192.168.171.255 ( all the last 5 bits value is 1) for broadcast addess.

<a name="r1-a"></a>
### Router-1
We added in the file `router-1.sh` the following lines:
  ```
ip link set dev eth1 up
ip link add link eth1 name eth1.170 type vlan id 170
ip link add link eth1 name eth1.171 type vlan id 171
ip add add 192.168.170.254/24 dev eth1.170
ip add add 192.168.171.254/27 dev eth1.171
ip link set eth1.170 up
ip link set eth1.171 up
   ```
```
ip link set dev eth1 up
```
Thanks to this line the port eth1 is created and also linked to the switch.
```
ip link add link eth1 name eth1.170 type vlan id 170
ip link add link eth1 name eth1.171 type vlan id 171
```
The port eth1 is splitted in two ports (eth1.170 and eth1.171): so VLANs virtually split the link. We call the two VLANs with the third 8 bits of IP configuration of the link.
```
ip add add 192.168.170.254/24 dev eth1.170
ip add add 192.168.171.254/27 dev eth1.171
```
The address is added to the two virtual ports.
```
ip link set eth1.170 up
ip link set eth1.171 up
```
The two ports are switched on.


#### IP
Router-1 has two different IP address on port eth1.

From the general IP address 192.168.168.0 we decided to use configuration 192.168.170.0/24 for the first VLAN the configuration 192.168.171.224/27 for the second VLAN.

Eth1.170 has IP 192.168.170.254 on the port that link router with host-1-a. That IP is /24 so there are enough IPs for all the 130 possible hosts in the net; 2 host can be reserved for the system.<br>
For eth1.171 we have the IP 192.168.171.254. This address is /27, so we have 32 IP: only 30 addesses are free; we use them for the hosts and they're enough for our system. 


<a name="h1a-a"></a>
### Host-1-a
We add these lines in the file `common.sh`:
  ```
ip link set dev eth1 up
ip add add 192.168.170.1/24 dev eth1
ip route add 192.168.168.0/21 via 192.168.170.254 
  ```
```
ip link set dev eth1 up
```
Port eth1 is created in the host-1-a.
```
ip add add 192.168.170.1/24 dev eth1
```
Address 192.168.170.1 is added to the port eth1; now the port can be used to link the host with other devices to send and recive packets.
```
ip route add 192.168.168.0/21 via 192.168.170.254
```
This line is used to add the route that a packet has to do. All the packet with address 192.168.168.0/21 (all the packets that have the same 21 bits of this address) have to be sent on the link to `router-1` (to the port with address 192.168.170.254).

#### IP
`Host-1-a` has an IP address on port eth1 linked to router-1 (192.168.170.1), which is the first address free in the configuration of the first VLAN. All hosts (252 hosts at the most), except the two of the system and the router's address, can use all the other addresses. 
<a name="h1b-a"></a>
### Host-1-b
We add the following lines in file `docker-1b.sh` to link `host-1-b` to the Network:
  ```
ip link set dev eth1 up
ip add add 192.168.171.225/27 dev eth1
ip route add 192.168.168.0/21 via 192.168.171.254
```
```  
ip link set dev eth1 up
```
Port eth1 of `host-1-b` is created: now the host can be linked to the Net.
```
ip add add 192.168.171.225/27 dev eth1
```
IP address 192.168.171.225 is added to `host-1-b`'s port eth1.

```
ip route add 192.168.168.0/21 via 192.168.171.254
```
With this line we add the route that all packets with an address of configuration 192.168.168.0/21 have to do to reach the right destination. All these packets have to travel through port eth1.171 of router that has IP 192.168.171.254.

#### IP
Host-1-b has an IP address at port eth1. It's 192.168.171.225. With this address and the port eth1 the host might send packets to the devices with an IP between 192.168.168.0 and 192.168.175.255 and also recived from these devices. All the packets have to pass through port eth1.171 of `router-1` at IP address 192.168.171.254.
<a name="s-a"></a>
### Switch
We add these lines in the file `switch.sh` to link switch with `host-1-a`, `host-1-b` and `router-1`:
```
ovs-vsctl add-br switch
ovs-vsctl add-port switch eth1
ovs-vsctl add-port switch eth2 tag=170
ovs-vsctl add-port switch eth3 tag=171
ip link set dev eth1 up
ip link set dev eth2 up
ip link set dev eth3 up
ip link set ovs-system up
```
The  ovs-vsctl  program  supports  the model of a bridge implemented by Open vSwitch (OVS). OVS simulates a Layer 2 learning switch which maintains a MAC address learning table. VMs connect to virtual ports on the switch. We uses the OpenFlow protocol to configure and communicate with Open vSwitch.
 ```
ovs-vsctl add-br switch
  ```
We need this line to configure the switch and use it like a bridge that connect hosts and router because we use multiple ports and VLANs.
```
ovs-vsctl add-port switch eth1
ovs-vsctl add-port switch eth2 tag=170
ovs-vsctl add-port switch eth3 tag=171
```
Three ports are added to the switch.  Port eth1 has no tag so it's a trunk port, instead of the other two ports (eth2 is tagged as value 170, eth3 is tagged as value 171). Tags are necessary to divide traffic from `router-1`, that came in eth1, to `host-1-a`'s VLAN in eth2 or to `host-1-b`'s VLAN through eth3. The switch reads the tag that router assigned to each packet before send it to eth1.
```
ip link set dev eth1 up
ip link set dev eth2 up
ip link set dev eth3 up
```
The three port eth1, eth2 and eth3, that connect switch with the other devices, are created and are swiched on. Now packets can be sent through switch.

<a name="B"></a>
## Subnet B
We'll call Subnet B the part of our Network that connects the two routers (`router-1` and `router-2`). This link is necessary to connect hosts in Subnet A to hosts in  Subnet C, so all the devices of our Net can send and recived packets from all the other devices.

This link only connects the two routers, so we decided to use as less bit for hosts as possible. 2 addresses are needed by the router, so we can't use only 1 bit: in fact two spaces are taken by the address space and broadcast address. So we have to use at least 2 bits for hosts' address, and we decided to use exactly 2 bit in order to have 4 IP addresses. <br>
192.168.173.0 is allocated to the address space, while 192.168.173.3 to the broadcast address (we have to use the IP with the last 2 bits to value 1). We added IP 192.168.173.1 to eth2 of `router-1`; the last IP 192.168.173.2 has become the address of eth2 of `router-2`.
<a name="r1-b"></a>
### Router-1
We add these lines to the file `router-1.sh` to link the two routers:
```
apt-get install -y frr --assume-yes --force-yes
ip link set dev eth2 up
ip add add 192.168.173.1/30 dev eth2
ip link set eth2 up
sysctl net.ipv4.ip_forward=1
sed -i "s/\(zebra *= *\). */\1yes/" /etc/frr/daemons
sed -i "s/\(ospfd *= *\). */\1yes/" /etc/frr/daemons
service frr restart
vtysh -c 'configure terminal' -c 'router ospf' -c 'redistribute connected'  -c 'exit' -c 'interface eth2' -c 'ip ospf area 0.0.0.0' -c 'exit' -c 'exit' -c 'write'
```

```
apt-get install -y frr --assume-yes --force-yes
```
This line is necessary to install in the router the FRRouting protocol that allows a dynamic routing between the routers

```
ip link set dev eth2 up
```
We use this line to create  port eth2 in  `router-1`. Each port is a link between the router and a different Subnet.

```
ip add add 192.168.173.1/30 dev eth2
```
This line is used to add an IP address to the new port. The port eth2 has IP 192.168.173.1.

```
ip link set eth2 up
```
We used this line to switch on and check the port eth2.

```
sysctl net.ipv4.ip_forward=1
```
We add this line for enable the forwarding that redirects each packets to the correct port using the IP address.

```
sed -i "s/\(zebra *= *\). */\1yes/" /etc/frr/daemons
sed -i "s/\(ospfd *= *\). */\1yes/" /etc/frr/daemons
service frr restart
vtysh -c 'configure terminal' -c 'router ospf' -c 'redistribute connected'  -c 'exit' -c 'interface eth2' -c 'ip ospf area 0.0.0.0' -c 'exit' -c 'exit' -c 'write'
```
These lines are used to configure in the right way the FRR and allow to link correctly the two router and consequently the different Subnet.

#### IP
`Router-1` has an IP on port eth2 and it's 192.168.173.1. The configuration of our network allows to use this IP, because that address is inside the address space 192.168.168.0/21. We can't use the first IP address of the Subnet (192.168.173.0) because it was reserved to address space.

### Router-2
We add the following lines to `router-2.sh` file that are necessary to link the two router:
```
apt-get install -y frr --assume-yes --force-yes
ip link set dev eth2 up
ip add add 192.168.173.2/30 dev eth2
ip link set eth2 up
sysctl net.ipv4.ip_forward=1
sed -i "s/\(zebra *= *\). */\1yes/" /etc/frr/daemons
sed -i "s/\(ospfd *= *\). */\1yes/" /etc/frr/daemons
service frr restart
vtysh -c 'configure terminal' -c 'router ospf' -c 'redistribute connected'  -c 'exit' -c 'interface eth2' -c 'ip ospf area 0.0.0.0' -c 'exit' -c 'exit' -c 'write'
```

```
apt-get install -y frr --assume-yes --force-yes
```
We use this line to install correctly the FRRouting that, link in the Router-1, allow to link the two router.

```
ip link set dev eth2 up
ip add add 192.168.173.2/30 dev eth2
ip link set eth2 up
```
We need these line to create the port eth2 of router-2 and add its the address 192.168.173.2.

```
sysctl net.ipv4.ip_forward=1
```
We used this line to enable the forwarding that is necessary to send each packet to the correct port.

```
sed -i "s/\(zebra *= *\). */\1yes/" /etc/frr/daemons
sed -i "s/\(ospfd *= *\). */\1yes/" /etc/frr/daemons
service frr restart
vtysh -c 'configure terminal' -c 'router ospf' -c 'redistribute connected'  -c 'exit' -c 'interface eth2' -c 'ip ospf area 0.0.0.0' -c 'exit' -c 'exit' -c 'write'
```
We use these lines to configure the FRR for link correctly the two router and consequently the all the Network.

#### IP
The `router-2` has on port eth2 the IP 192.168.173.2. This is the last free address; this Subnet has 30 bits used for the net and only the last 2 for hosts. Two bits fit to 4 different address: two of them are used for address space and broadcast and the other two are used for the routers. 


<a name="C"></a>
## Subnet C
Subnet C is the part of the Network that links `router-2` to `host-2-c`. Using this link and the previous ones we can satisfy the request to link `host-1-a` and `host-1-b` to `host-2-c`.

This subnet doesn't need serveral IP addresses, so we decided to use only 2 bits for the hosts and the other 30 for the net. We need all the 4 (2^2) IP address. The first (192.168.172.228), with the last two bits at value 0, is for the address space. Then we assigned the second one (192.168.172.229) to port eth1 of `host-2-c` and the third one (192.168.172.230) to port eth1 of `router-2`. So broadcast address (it must ends with two bits 1) is 192.168.172.231.

<a name="r2-c"></a>
### Router-2
In the Subnet B we have already explain the `router-2` codes. There we talked about OSPF protocol in depth. Now we well explain the code we use in order to set up Subnet C.
```
ip link set dev eth1 up
ip add add 192.168.172.230/30 dev eth1
ip link set eth1 up
```
Initially we bring eht1 up. Then we assign an IPv4 address to the interface eht1. The third line activate the link.

#### IP
The `router-2` has on port eth1 the IP 192.168.172.230. This Subnet has 30 bits used for the net; as a result only the last 2 bits are dedicated to the host (2 addresses are taken from address space and broadcast).

<a name="h2c-c"></a>
### Host-2-c 
In the file `docker-2c.sh` you can find these commands:

```
ip link set dev eth1 up
```
We add this line to create the port eth1 in the host-2-c.
```
ip add add 192.168.172.229/30 dev eth1
```
We use this line to add an address to the port eth1; now we can use this port to link the host with other device to send and recive packet.

```
ip route add 192.168.168.0/21 via 192.168.172.230
```
This line is used to add the route that a packet has to do. It say that all the packets with address 192.168.168.0/21, so all the packets that have the same 21 bits of this address, have to be send on the link with router-2 at address 192.168.172.230.
#### IP
Host-2-c has an IP address on port eth1 linked to router-2. It's 192.168.172.229 and it's the first address free in the configuration of this subnet. In this Subnet we used all the possible IP adresses: two for the system, one for the `router-2` and this one for `host-2-c`.

#### Docker
We need to set up the Docker repository.  As a precaution, we decided to uninstall older versions of Docker when they were present.
```
apt-get remove docker docker-engine docker.io
apt-get update --assume-yes --force-yes
apt-get install apt-transport-https --assume-yes --force-yes
apt-get install ca-certificates --assume-yes --force-yes
apt-get install curl --assume-yes --force-yes
apt-get install software-properties-common --assume-yes --force-yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
```

Now we can install and update Docker from the repository.
```
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce --assume-yes --force-yes
```
The next step is to build a web page to serve on nginx: we'll create a custom index page for our website.
We create a new directory for our website content within our home directory, and move to it, by running the commands shown below. Then we use the text editor touch to create an HTML file.
```
mkdir -p ~/docker-nginx/html
cd ~/docker-nginx/html
touch index.html
```
First of all we cleaned the file and then we put the website's  html code into it.
```
truncate -s 0 index.html
echo " -----  " >> index.html
```
FInally we link the container to the local filesystem by creating a new Nginx container (our virtual machine will be located in port 80).
```
docker rm docker-nginx
docker run --name docker-nginx -p 80:80 -d -v ~/docker-nginx/html:/usr/share/nginx/html nginx
```
<a name="How"></a>
# How-to
<a name="Requirements"></a>
## Requirements
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet
<a name="Display"></a>
## Display the website
 - Install Virtualbox and Vagrant
 - Clone this repository `git clone` https://github.com/mattybass/dncs-lab
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up --provision
```
Once you launch the vagrant script, it may take some minutes (this value depends on you PC power) for the entire topology to become available. Do not worry if during the configuration the display will show you some errors: they won't undermine the machines' functioning.
 Now you can verify the status of the 4 VMs using the command
 ```
 [dncs-lab]$ vagrant status      
 ```
 If everything goes weel the terminal will show you                                                                                                                                                          
 ```
Current machine states:

router-1                  running (virtualbox)
router-2                  running (virtualbox)
switch                    running (virtualbox)
host-1-a                  running (virtualbox)
host-1-b                  running (virtualbox)
host-2-c                  running (virtualbox)
 ```
The request is to reach a website hosted on `host-2-c` from any host configured and attached to `router-1` (`host-1-a` and `host-1-b`). So, once all the VMs are running you can log into `host-1-a` and `host-1-b` (you have to duplicate the terminal or to log into the hosts in two different times: if you want to exit from an host type `exit`) using these commands (in two different windows):
```
vagrant ssh host-1-a
```
```
vagrant ssh host-1-b
```
The terminal will show you in each case:
```
Welcome to Ubuntu 14.04.3 LTS (GNU/Linux 3.16.0-55-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Development Environment
```
Then get the root permission of the two terminals using the command
```
sudo su
```

In order to browse the website type the command
```
curl 192.168.172.229
```
The vagrant response is going to be:

```
<!DOCTYPE html>
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
```
This is the htlm code of the website hosted on `host-2-c`.
<a name="Test"></a>
## Test the network
<a name="r1-h"></a>
 ### Router-1
Log into the router using 
```
vagrant ssh router-1
```
```
sudo su
```
In order to look if `router-1` is working you can ping (use the command `ping` followed by the IP-address of the host/router you want to check) any net device.

For example pinging the `host-1-b`
```
ping 192.168.171.225
```
 you are going to have a response like that
```
PING 192.168.171.225 (192.168.171.225) 56(84) bytes of data.
64 bytes from 192.168.171.225: icmp_seq=1 ttl=64 time=8.08 ms
64 bytes from 192.168.171.225: icmp_seq=2 ttl=64 time=3.23 ms
64 bytes from 192.168.171.225: icmp_seq=3 ttl=64 time=5.30 ms
64 bytes from 192.168.171.225: icmp_seq=4 ttl=64 time=7.64 ms
64 bytes from 192.168.171.225: icmp_seq=5 ttl=64 time=4.03 ms

--- 192.168.171.225 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4012ms
rtt min/avg/max/mdev = 3.234/5.658/8.085/1.921 ms
```
You can also check the routing table, which is configurend thanks to ospf routing protocol.
```
route -nve
```
```
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         10.0.2.2        0.0.0.0         UG        0 0          0 eth0
10.0.2.0        0.0.0.0         255.255.255.0   U         0 0          0 eth0
192.168.170.0   0.0.0.0         255.255.255.0   U         0 0          0 eth1.170
192.168.171.224 0.0.0.0         255.255.255.224 U         0 0          0 eth1.171
192.168.172.228 192.168.173.2   255.255.255.252 UG        0 0          0 eth2
192.168.173.0   0.0.0.0         255.255.255.252 U         0 0          0 eth2
```
You can also execute the `ifconfig` command.

```
eth0      Link encap:Ethernet  HWaddr 08:00:27:20:c5:44
          inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:fe20:c544/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:28521 errors:0 dropped:0 overruns:0 frame:0
          TX packets:13092 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:23312504 (23.3 MB)  TX bytes:934486 (934.4 KB)

eth1      Link encap:Ethernet  HWaddr 08:00:27:a9:ef:61
          inet6 addr: fe80::a00:27ff:fea9:ef61/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:992 errors:0 dropped:0 overruns:0 frame:0
          TX packets:413 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:329947 (329.9 KB)  TX bytes:126740 (126.7 KB)

eth2      Link encap:Ethernet  HWaddr 08:00:27:3e:dc:0f
          inet addr:192.168.173.1  Bcast:0.0.0.0  Mask:255.255.255.252
          inet6 addr: fe80::a00:27ff:fe3e:dc0f/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1218 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1285 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:190092 (190.0 KB)  TX bytes:202051 (202.0 KB)

eth1.170  Link encap:Ethernet  HWaddr 08:00:27:a9:ef:61
          inet addr:192.168.170.254  Bcast:0.0.0.0  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:fea9:ef61/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:309 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:101352 (101.3 KB)  TX bytes:648 (648.0 B)

eth1.171  Link encap:Ethernet  HWaddr 08:00:27:a9:ef:61
          inet addr:192.168.171.254  Bcast:0.0.0.0  Mask:255.255.255.224
          inet6 addr: fe80::a00:27ff:fea9:ef61/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:348 errors:0 dropped:0 overruns:0 frame:0
          TX packets:43 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:104827 (104.8 KB)  TX bytes:4304 (4.3 KB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```     
<a name="r2-h"></a> 
 ### Router-2
As well as `router-1` log into the router and ping another device to look if it's working.
```
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         10.0.2.2        0.0.0.0         UG        0 0          0 eth0
10.0.2.0        0.0.0.0         255.255.255.0   U         0 0          0 eth0
192.168.170.0   192.168.173.1   255.255.255.0   UG        0 0          0 eth2
192.168.171.224 192.168.173.1   255.255.255.224 UG        0 0          0 eth2
192.168.172.228 0.0.0.0         255.255.255.252 U         0 0          0 eth1
192.168.173.0   0.0.0.0         255.255.255.252 U         0 0          0 eth2
```

You can also check the routing table execute the `ifconfig` command.
```
eth0      Link encap:Ethernet  HWaddr 08:00:27:20:c5:44
          inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:fe20:c544/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:25042 errors:0 dropped:0 overruns:0 frame:0
          TX packets:9539 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:23119005 (23.1 MB)  TX bytes:712269 (712.2 KB)

eth1      Link encap:Ethernet  HWaddr 08:00:27:60:7a:b6
          inet addr:192.168.172.230  Bcast:0.0.0.0  Mask:255.255.255.252
          inet6 addr: fe80::a00:27ff:fe60:7ab6/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:352 errors:0 dropped:0 overruns:0 frame:0
          TX packets:413 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:119050 (119.0 KB)  TX bytes:136749 (136.7 KB)

eth2      Link encap:Ethernet  HWaddr 08:00:27:44:c8:3e
          inet addr:192.168.173.2  Bcast:0.0.0.0  Mask:255.255.255.252
          inet6 addr: fe80::a00:27ff:fe44:c83e/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1374 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1368 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:215353 (215.3 KB)  TX bytes:211188 (211.1 KB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```
<a name="s-h"></a>
### Switch
Log into the switch using 
```
vagrant ssh switch
```
```
sudo su
```
In order to show OpenFlow information on the switch (OpenFlow features and port descriptions) use the command
```ovs-vsctl show```
```
    Bridge switch
        Port "eth3"
            tag: 171
            Interface "eth3"
        Port switch
            Interface switch
                type: internal
        Port "eth1"
            Interface "eth1"
        Port "eth2"
            tag: 170
            Interface "eth2"
    ovs_version: "2.0.2"
```
We can see the ports' name and also if they are associated to a VLAN. `Eth1` is a trunk port: it's a link between `switch` and `router-1`. Otherwise `Eth2` and `Eth3` are access port: they take the packets they receive and retag them.

You can also execute the `ifconfig` command for controlling network interface.
```
eth0      Link encap:Ethernet  HWaddr 08:00:27:20:c5:44
          inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:fe20:c544/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:15948 errors:0 dropped:0 overruns:0 frame:0
          TX packets:6069 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:14188670 (14.1 MB)  TX bytes:478970 (478.9 KB)

eth1      Link encap:Ethernet  HWaddr 08:00:27:fb:e3:44
          inet6 addr: fe80::a00:27ff:fefb:e344/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:289 errors:0 dropped:0 overruns:0 frame:0
          TX packets:789 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:97504 (97.5 KB)  TX bytes:259329 (259.3 KB)

eth2      Link encap:Ethernet  HWaddr 08:00:27:86:53:4a
          inet6 addr: fe80::a00:27ff:fe86:534a/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:250 errors:0 dropped:0 overruns:0 frame:0
          TX packets:287 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:83412 (83.4 KB)  TX bytes:96066 (96.0 KB)

eth3      Link encap:Ethernet  HWaddr 08:00:27:fe:9f:5b
          inet6 addr: fe80::a00:27ff:fefe:9f5b/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:261 errors:0 dropped:0 overruns:0 frame:0
          TX packets:285 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:84765 (84.7 KB)  TX bytes:94048 (94.0 KB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

ovs-system Link encap:Ethernet  HWaddr f6:c0:1e:2d:71:74
          inet6 addr: fe80::f4c0:1eff:fe2d:7174/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:648 (648.0 B)

switch    Link encap:Ethernet  HWaddr 08:00:27:86:53:4a
          inet6 addr: fe80::c853:39ff:fe91:e55c/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:774 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:260250 (260.2 KB)  TX bytes:648 (648.0 B)
```
<a name="h1a-h"></a>
 ### Host-1-a
 Check if `host-1-a` is working by logging into the router and pinging another device. You can also execute the `ifconfig` command for controlling network interface.
<a name="h1b-h"></a>
 ### Host-1-b
 Check if `host-1-b` is working by logging into the router and pinging another device. You can also execute the `ifconfig` command for controlling network interface.
<a name="h2c-h"></a>
 ### Host-2-c
 Check if `host-1-b` is working by logging into the router and pinging another device. You can also execute the `ifconfig` command for controlling network interface.<br>
 In this host we installed a docker container. You can see information about it thank to the command
 ```
 docker ps -a
 ```
We can see some basic information about our container.
 ```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
390e0079bb45        nginx               "nginx -g 'daemon of…"   4 hours ago         Up 4 hours          0.0.0.0:80->80/tcp   docker-nginx
 ```



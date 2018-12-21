# DNCS-LAB

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


# Requirements
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/dustnic/dncs-lab`
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
The request is to reach a website hosted on `host-2-c` any host configured and attached to `router-1` (`host-1-a` and `host-1-c`). So, once all the VMs are running you can log into `host-1-a` and `host-1-b` using these commands:
```
vagrant ssh host-1-a
vagrant ssh host-1-b
```
The terminal will show you in each case:
```
Welcome to Ubuntu 14.04.3 LTS (GNU/Linux 3.16.0-55-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Development Environment

Then get the root permission of the two terminals using the command
`sudo su` .
```
In order to browse the website type the command `curl 192.168.172.229`:
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


# Network Map
  All the device of our Network can be reach using the broadcast address 192.168.168.000 and the subnet mask is 255.255.248.000.
  The Network can also be divid in three Subnetwork. 

  

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





  In the first (A) there are host-1-a, host-1-b, switch and router-1; This net is split in two vlan. The vlan with the tag 170 link router-1 with host-1-a, on the other side we have vlan 171 that link always router-1 with host-1-b. <br>
  The second (B) Subnetwork link the two router of the topology eachother. <br>
  In the last one, the third (C) the net link router-2 with host-2-c.

## Subnet A
  We'll call subnet A the part of the network in which we can find router-1, switch, host-1-a and host-1-b. We split the link between the port eth1 of the router and the port eth1 of the switch in two vlan, so we can use the same physical link to connect two different host through the switch.

  The VLAN that link router-1 to host-1-a has 24 bit reserved and only 8 bit for the hosts but its enough for our configuration. In fact we have 2^8 (256) different IP address, but we can't use all it. We have to reserved 2 IP, the first one 192.168.170.0 is for IP address space (it has all the last 8 bit at zero) and the last one is the broadcast address 192.168.170.255 (it has all the last 8 bit at one). We decided to use the first free IP address for the port eth1 of the host-1-a (192.168.170.1) and the last free for the port eth1.170 of the router (192.168.170.254).
  Even thought 254 different IP adress are enough for the assigment request of 130 hosts. If we had used 7 bits for host we would have only 128 different IP address.

  On the other side the VLAN that link router-1 to host-1-b has 27 bit reserved for the Net and only 5 for the hosts. In this case we need at least 25 different IP address and the 2^5 (32) address are enough for IP address space, broadcast address and hosts.
  The firt IP has to be use for IP address space and in our configuration is 192.168.171.224, the second 192.168.171.225 the decided to use for port eth1 of host-1-b. We used the second-last 192.168.171.254 for eth1.171 of router-1 and lastly we have to use the last IP 192.168.171.255, with all the last 5 bit ad one for broadcast addess.


### Router-1
  We added in the file router-1.sh the following lines:
  ```
   ip link set dev eth1 up
   ip link add link eth1 name eth1.170 type vlan id 170
   ip link add link eth1 name eth1.171 type vlan id 171
   ip add add 192.168.170.254/24 dev eth1.170
   ip add add 192.168.171.254/27 dev eth1.171
   ip link set eth1.170 up
   ip link set eth1.171 up
   ```

  `ip link set dev eth1 up` 
  We need this line to create the port eth1 that is link to the switch.

  ```ip link add link eth1 name eth1.170 type vlan id 170
   ip link add link eth1 name eth1.171 type vlan id 171```
  We use there lines to split the port eth1 in two ports (eth1.170 and eth1.171) to use the VLAN that virtualy split the link. We call the two VLAN with the third 8 bits of IP configuration of the link.

  ```ip add add 192.168.170.254/24 dev eth1.170
   ip add add 192.168.171.254/27 dev eth1.171```
  With this lines we add the address to the two virtual ports.

  ```ip link set eth1.170 up
   ip link set eth1.171 up```
  Now we can use there lines to 'switch on' the two ports.


#### IP


  




  Its IP address space is 192.168.168.0, the subnet mask is 255.255.175.000 and the broadcast address is 192.168.175.255; so we have 21 bit for the net and we use only 
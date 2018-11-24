# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1 -> 192.168.172.230
        |  N  |                      |                           |
        |  A  |                      |                           |eth1 -> 192.168.172.229
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           | host-2-c |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+ host-1-a |     | host-1-b |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```



# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/dustnic/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`


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

# The Network
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

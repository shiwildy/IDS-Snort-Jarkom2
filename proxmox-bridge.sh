#!/bin/bash

brctl show vmbr1 # sesuaikan dengan interface bridge

# >> tambahkan tc ingress ke interface bridge
tc qdisc add dev vmbr1 ingress

# >> Tambah filter untuk melempar seluruh informasi lubang ke lubang interface ids
tc filter add dev vmbr1 parent ffff: protocol all prio 10 u32 match u32 0 0 action mirred egress mirror dev veth200i0

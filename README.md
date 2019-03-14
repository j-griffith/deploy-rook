# Rook Deployment Scripts

This repo is a work in progress I use to quickly deploy Rook/Ceph RBD CSI Plugin on a K8s Cluster

Modify any manifests as needed, then...
Run the bash scripts in sequence, `setup-[1,2,3].bash`

They're seperated because you have to wait for the operators in 1 and 2 to finish their deployments.

## Prerequisites

This setup is expecting a minimum of two worker nodes (3 is better).

## Tips

After launching `setup-1.bash`, you should eventually see 3 ceph mons (a,b,c) and two osd's.  If you
see your mons, but they're not ordered `a,b,c` but something like `a,d,c` etc, that usually means you
had a left over rook config file hanging around, or something just went wrong.  Run teardown.sh, log
on to each K8s worker node and `rm -rf /var/lib/rook`

The `setup-2.bash` script will run the ceph-csi operator and install the ceph-rbd-csi plugins and associated
side-cars.  I currently comment out the cephfs deployment and the files are not in this repo, but this is all
pretty much the default from the rook repo, so easy enough to add them.

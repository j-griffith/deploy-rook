#!/bin/bash

cat << EOF | kubectl create -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
   name: csi-rbd-xfs
provisioner: csi-rbdplugin
parameters:
    # Comma separated list of Ceph monitors
    # if using FQDN, make sure csi plugin's dns policy is appropriate.
    monitors: rook-ceph-mon-b.rook-ceph.svc.cluster.local:6789

    # if "monitors" parameter is not set, driver to get monitors from same
    # secret as admin/user credentials. "monValueFromSecret" provides the
    # key in the secret whose value is the mons
    #monValueFromSecret: "monitors"


    # Ceph pool into which the RBD image shall be created
    pool: rbd

    # RBD image format. Defaults to "2".
    imageFormat: "2"

    # RBD image features. Available for imageFormat: "2". CSI RBD currently supports only `layering` feature.
    imageFeatures: layering

    # The secrets have to contain Ceph admin credentials.
    #csi.storage.k8s.io/provisioner-secret-name: csi-rbd-secret
    #csi.storage.k8s.io/provisioner-secret-namespace: default
    #csi.storage.k8s.io/node-publish-secret-name: csi-rbd-secret
    #csi.storage.k8s.io/node-publish-secret-namespace: default
    csiProvisionerSecretName: csi-rbd-secret
    csiProvisionerSecretNamespace: default
    csiNodePublishSecretName: csi-rbd-secret
    csiNodePublishSecretNamespace: default

    # Ceph users for operating RBD
    adminid: admin
    userid: admin
    #userid: kubernetes
    # uncomment the following to use rbd-nbd as mounter on supported nodes
    #mounter: rbd-nbd
    fsType: xfs
reclaimPolicy: Delete
EOF


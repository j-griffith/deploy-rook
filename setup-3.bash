cat << EOF | kubectl create -f -
apiVersion: ceph.rook.io/v1
kind: CephBlockPool
metadata:
  name: rbd
  namespace: rook-ceph
spec:
  failureDomain: host
  replicated:
    size: 3
EOF


# Run this script to setup keys and create SC:  https://gist.github.com/j-griffith/002c040231859678744e35636e876928
key=$(pod=$(kubectl get pod  -n rook-ceph-system -l app=rook-ceph-operator  -o jsonpath="{.items[0].metadata.name}"); kubectl exec -ti -n rook-ceph-system ${pod} -- bash -c "ceph auth get-key client.admin -c /var/lib/rook/rook-ceph/rook-ceph.config | base64")

cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Secret
metadata:
  name: csi-rbd-secret
  namespace: default
data:
  # Key value corresponds to a user name defined in ceph cluster
  # Key value corresponds to a user name defined in ceph cluster
  adminID: YWRtaW4=
  monitors: cm9vay1jZXBoLW1vbi1iLnJvb2stY2VwaC5zdmMuY2x1c3Rlci5sb2NhbDo2Nzkw
  admin: ${key}
  adminKey: ${key}
EOF

cat << EOF | kubectl create -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
   name: csi-rbd
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
    multiNodeWritable: "enabled"

reclaimPolicy: Delete
EOF

kubectl patch storageclass csi-rbd -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

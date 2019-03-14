echo "create rbac and config maps"
kubectl apply -f ./ceph-manifests/csi/rbac/rbd/
#kubectl apply -f ./ceph-manifests/csi/rbac/cephfs/

#kubectl create configmap csi-cephfs-config -n rook-ceph-system --from-file="/home/jgriffith/go/src/github.com/rook/rook/cluster/examples/kubernetes/ceph/csi/template/cephfs/"
kubectl create configmap csi-rbd-config -n rook-ceph-system --from-file="/home/jgriffith/go/src/github.com/rook/rook/cluster/examples/kubernetes/ceph/csi/template/rbd/"

echo "Deploy the ceph-with-csi operator"
kubectl apply -f ./ceph-manifests/operator-with-csi.yaml

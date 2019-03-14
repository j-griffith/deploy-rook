kubectl delete -n rook-ceph cephblockpool replicapool
kubectl delete storageclass rook-ceph-block
kubectl delete -f kube-registry.yaml
kubectl -n rook-ceph delete cephcluster rook-ceph
kubectl delete -f /home/jgriffith/go/src/github.com/rook/rook/cluster/examples/kubernetes/ceph/operator-with-csi.yaml

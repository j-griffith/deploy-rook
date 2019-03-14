echo "Create base rook/ceph"
kubectl create -f ./ceph-manifests/operator.yaml
kubectl create -f ./ceph-manifests/cluster.yaml


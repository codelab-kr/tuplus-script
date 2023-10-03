#
# Remove containers from Kubernetes.
#
# Usage:
#
#   cd ./scripts/production-kub 
#   ./delete.sh
#

# kubectl --kubeconfig ~/.kube/config -n tuflix  delete -f rabbit.yaml
# kubectl --kubeconfig ~/.kube/config -n tuflix  delete -f mongodb.yaml
envsubst <metadata.yaml | kubectl --kubeconfig ~/.kube/config -n tuflix  delete -f -
envsubst <history.yaml | kubectl --kubeconfig ~/.kube/config -n tuflix  delete -f -
# envsubst <mock-storage.yaml | kubectl --kubeconfig ~/.kube/config -n tuflix  delete -f -
envsubst <oci-storage.yaml | kubectl --kubeconfig ~/.kube/config -n tuflix  delete -f -
envsubst <video-streaming.yaml | kubectl --kubeconfig ~/.kube/config -n tuflix  delete -f -
envsubst <video-upload.yaml | kubectl --kubeconfig ~/.kube/config -n tuflix  delete -f -
envsubst <gateway.yaml | kubectl --kubeconfig ~/.kube/config -n tuflix  delete -f -

kubectl --kubeconfig ~/.kube/config -n tuflix  delete secret free-registry-secret 
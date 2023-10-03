#
# Builds, publishes and deploys all microservices to a production Kubernetes instance.
#
# Usage:
#   
#   cd scripts/production-kub 
#   ./deploy.sh

# kubectl --kubeconfig ~/.kube/config create namespace tuflix

docker login -u cnqphqevfxnp/codelab -p '}96sOiOo]QW+KP)uoxkD' ap-seoul-1.ocir.io ;  # Use your own credentials

kubectl -n tuflix --kubeconfig ~/.kube/config create secret docker-registry free-registry-secret --docker-server=ap-seoul-1.ocir.io --docker-username='cnqphqevfxnp/codelab' --docker-password='}96sOiOo]QW+KP)uoxkD' --

export CONTAINER_REGISTRY=ap-seoul-1.ocir.io/cnqphqevfxnp
export OCI_CONFIG=$(cat /Users/bm/workspace/cloud/tuflix/oci-storage/.oci/config) 
export OCI_CLI_KEY_CONTENT=$(cat /Users/bm/workspace/cloud/tuflix/oci-storage/.oci/key.pem)
export NAMESPACE=cnqphqevfxnp
export BUCKET_NAME=tuflix-bucket

set -u # or set -o nounset
: "$CONTAINER_REGISTRY"
: "$NAMESPACE"
: "$BUCKET_NAME"

# Build Docker images.

docker build --platform linux/arm64 -t $CONTAINER_REGISTRY/metadata:1 --file ../../metadata/Dockerfile-prod ../../metadata
docker push $CONTAINER_REGISTRY/metadata:1

docker build --platform linux/arm64 -t $CONTAINER_REGISTRY/history:1 --file ../../history/Dockerfile-prod ../../history
docker push $CONTAINER_REGISTRY/history:1

# docker build --platform linux/arm64 -t $CONTAINER_REGISTRY/mock-storage:1 --file ../../mock-storage/Dockerfile-prod ../../mock-storage
# docker push $CONTAINER_REGISTRY/mock-storage:1

docker buildx build --platform linux/arm64 --build-arg OCI_CONFIG="${OCI_CONFIG}" --build-arg OCI_CLI_KEY_CONTENT="${OCI_CLI_KEY_CONTENT}" -t $CONTAINER_REGISTRY/oci-storage:1 --file ../../oci-storage/Dockerfile-prod ../../oci-storage
docker push $CONTAINER_REGISTRY/oci-storage:1

docker build --platform linux/arm64 -t $CONTAINER_REGISTRY/history:1 --file ../../history/Dockerfile-prod ../../history
docker push $CONTAINER_REGISTRY/history:1

docker build --platform linux/arm64 -t $CONTAINER_REGISTRY/video-streaming:1 --file ../../video-streaming/Dockerfile-prod ../../video-streaming
docker push $CONTAINER_REGISTRY/video-streaming:1

docker build --platform linux/arm64 -t $CONTAINER_REGISTRY/video-upload:1 --file ../../video-upload/Dockerfile-prod ../../video-upload
docker push $CONTAINER_REGISTRY/video-upload:1

docker build --platform linux/arm64 -t $CONTAINER_REGISTRY/gateway:1 --file ../../gateway/Dockerfile-prod ../../gateway
docker push $CONTAINER_REGISTRY/gateway:1


# Deploy containers to Kubernetes.
# Don't forget to change kubectl to your production Kubernetes instance


kubectl -n tuflix --kubeconfig ~/.kube/config apply -f rabbit.yaml
kubectl -n tuflix --kubeconfig ~/.kube/config apply -f mongodb.yaml
envsubst <metadata.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -
envsubst <history.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -
# envsubst <mock-storage.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -
envsubst <oci-storage.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -
envsubst <video-streaming.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -
envsubst <video-upload.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -
envsubst <gateway.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -



# # --------------- 춘천 배포 -----------------
# # Usage:
# #   kubectl -n chuncheon-free-ns create secret docker-registry free-registry-secret --docker-server=ap-chuncheon-1.ocir.io --docker-username='axdyhrbstmwy/codelab' --docker-password='<token>' --
# #   docker login -u axdyhrbstmwy/codelab ap-chuncheon-1.ocir.io  # Use your own credentials

  
# #   cd scripts/production-kub 
# #   ./deploy.sh


# export CONTAINER_REGISTRY=ap-chuncheon-1.ocir.io/axdyhrbstmwy
# export OCI_CONFIG=$(cat /Users/bm/workspace/cloud/tuflix/oci-storage/.oci/config-ch) 
# export OCI_CLI_KEY_CONTENT=$(cat /Users/bm/workspace/cloud/tuflix/oci-storage/.oci/key.pem)
# export NAMESPACE=axdyhrbstmwy
# export BUCKET_NAME=video-bucket  # ???

# set -u # or set -o nounset
# : "$CONTAINER_REGISTRY"

# # 빌드는 위와 동일

# kubectl -n chuncheon-free-ns apply -f rabbit.yaml
# kubectl -n chuncheon-free-ns apply -f mongodb.yaml
# envsubst <metadata.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -
# envsubst <history.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -
# # envsubst <mock-storage.yaml | kubectl -n chuncheon-free-ns apply -f -
# envsubst <video-streaming.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -
# envsubst <video-upload.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -
# envsubst <gateway.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -


# ---------------참고용 1개 수동 배포 -----------------
# export CONTAINER_REGISTRY=ap-seoul-1.ocir.io/cnqphqevfxnp
# export OCI_CONFIG=$(cat /Users/bm/workspace/cloud/tuflix/oci-storage/.oci/config) 
# export OCI_CLI_KEY_CONTENT=$(cat /Users/bm/workspace/cloud/tuflix/oci-storage/.oci/key.pem)
# export NAMESPACE=cnqphqevfxnp
# export BUCKET_NAME=tuflix-bucket

# echo $CONTAINER_REGISTRY
# echo $OCI_CONFIG
# echo $OCI_CLI_KEY_CONTENT
# echo $NAMESPACE
# echo $BUCKET_NAME

# set -u # or set -o nounset
# : "$CONTAINER_REGISTRY"

# docker buildx build --platform linux/arm64 --build-arg OCI_CONFIG="${OCI_CONFIG}" --build-arg OCI_CLI_KEY_CONTENT="${OCI_CLI_KEY_CONTENT}" --build-arg NAMESPACE=$NAMESPACE --build-arg BUCKET_NAME=$BUCKET_NAME  -t $CONTAINER_REGISTRY/oci-storage:1 --file ../../oci-storage/Dockerfile-prod ../../oci-storage
# docker push $CONTAINER_REGISTRY/oci-storage:1

# envsubst <oci-storage.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config apply -f -
# # envsubst <oci-storage.yaml | kubectl -n tuflix --kubeconfig ~/.kube/config delete -f -
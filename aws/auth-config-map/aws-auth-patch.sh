#!/bin/sh

set -e

cat >/tmp/ca.crt <<EOS
$KUBE_CA_DATA
EOS

aws_auth_config_map() {
  cat <<YAML
apiVersion: v1
kind: ConfigMap

metadata:
  name: aws-auth
  namespace: kube-system

data:
  mapRoles: |
YAML
  echo "$MAP_ROLES"
}

kubectl \
  --server="$KUBE_SERVER" \
  --certificate-authority=/tmp/ca.crt \
  --token="$KUBE_TOKEN" \
  patch \
  -n kube-system
  configmap aws-auth \
  -p "$(aws_auth_config_map)"

#!/bin/sh

set -x

kind create cluster \
  --wait 120s \
  --config - <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: glu-gitops-example
nodes:
- extraPortMappings:
  - containerPort: 30080 # example application
    hostPort: 30080
  
EOF

if ! command -v go 2>&1 >/dev/null; then
  echo "Please install Go (>=1.23)"
  exit 1
fi

if ! command -v timoni 2>&1 >/dev/null; then
  go install github.com/stefanprodan/timoni/cmd/timoni@latest
fi

timoni bundle apply --kube-context kind-glu-gitops-example -f timoni/flux-aio.cue
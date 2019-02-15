#!/usr/bin/env bash

mandatoryIngressSetup() {
  kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
}

main() {
  mandatoryIngressSetup
}

main
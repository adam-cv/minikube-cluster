#!/bin/sh -eu

## Sets up the port fowarding needed to access the minikube cluster
(kubectl port-forward svc/argocd-server -n argocd 8080:443 &) && 
#(kubectl port-forward -n kafka svc/kafka-ui 8001:80 &) &&
(kubectl port-forward -n kubernetes-dashboard svc/kubernetes-dashboard 8002:80) 

ps x |grep  kubectl |grep -v grep |awk '{print $1}' | xargs kill -9

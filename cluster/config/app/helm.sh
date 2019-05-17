kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}' deployment.extensions "tiller-deploy" patched
kubectl get deploy -n kube-system   tiller-deploy  --output yaml | grep  serviceAccount
kubectl -n kube-system get pods | grep tiller
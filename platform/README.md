# Flightdeck Workload Platform

Deploys the [Flightdeck Platform] to a Kubernetes cluster. If you're deploying
on AWS, you want the [platform for AWS](../aws).

The following components are included:

- [CertManager](https://cert-manager.io/)
- [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/README.md)
- [Fluent Bit](https://fluentbit.io/)
- [Istio](https://istio.io/)
- [Metrics Server](https://github.com/kubernetes-sigs/metrics-server)
- [Prometheus Adapter](https://github.com/kubernetes-sigs/prometheus-adapter)
- [Prometheus Operator](https://prometheus-operator.dev/)
- [Reloader](https://github.com/stakater/Reloader)
- [Secrets Store CSI Driver](https://secrets-store-csi-driver.sigs.k8s.io/)
- [Sloth](https://sloth.dev/)
- [Vertical Pod Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md)

Components are pre-configured to work with each other and support SRE best
practices.

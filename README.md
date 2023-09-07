# Flightdeck

[Terraform] modules for rapidly building production-grade Kubernetes clusters
with built-in support for SRE best practices.

These modules are provided by thoughtbot. These are the modules we use when
following SRE practices for our clients. We can help you scale your application,
improve stability, and increase the rate of defect-free deployments. You can
learn more on the [thoughtbot website].

<!-- Would it be helpful to have some or all this content integrated into the repo? The persona of this repo may benifit from a more technical view expressed in this website link.-->
[thoughtbot website]: https://thoughtbot.com/services/site-reliability
<!-- Are these TF modules, and are the Helm charts all loosely coupled?  If there are necessary tight couplings, either in TF deployments of grouped modules or in dependant charts, how would the implementer understand these nuances? As an example, are Prometheus or Istio optional, while secrets management is assumed to be required? -->
![AWS Architecture](./docs/aws-modules.png)

[terraform]: https://www.terraform.io/

## Deployment

- [AWS](./aws/README.md)
<!-- Does "Other" intend to cover all targets that are not AWS, such as GCP with GKE and Azure with AKS, in addition to bare metal K8s? Or is it intended for non CSP managed instances (e.g. GCP and Azure would have variations of AWS, and "Other" would be unmanaged infra"). -->
- [Other](./platform/README.md)

## Development
<!-- How would a technical audience get started?  Is there a minimal deployment and/or simple steps one could perform to get their feet wet? -->
Please see [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

This project is Copyright © 2022 Joe Ferris and thoughtbot. It is free
software, and may be redistributed under the terms specified in the [LICENSE]
file.

[license]: ./LICENSE

## About thoughtbot

![thoughtbot](https://thoughtbot.com/brand_assets/93:44.svg)

This project is maintained and funded by thoughtbot, inc. The names and logos
for thoughtbot are trademarks of thoughtbot, inc.

We love open source software! See [our other projects][community] or [hire
us][hire] to design, develop, and grow your product.

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github

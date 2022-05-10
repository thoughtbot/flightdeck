# Service Account Policy

This module creates an [IAM policy] which can be attached to the IAM roles for
your service accounts, granting pods access to the AWS resources specified in
the policy.

Example:

```
module "policy" {
  source = "github.com/thoughtbot/flightdeck//aws/service-account-policy"

  name       = "myservice-production"
  role_names = module.role.name

  policy_documents = [
    # If you have modules which produce JSON policies, you can attach them here
    module.database.policy_json,
    module.ses_sender.policy_json,

    # If you have your own custom policies, you can attach those as well
    data.aws_iam_policy_document.my_custom_policy.json
  ]
}
```

You can combine this module with the [service account role module] to grant
access to AWS services for your pods.

[iam policy]: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
[service account policy module]: ../service-account-policy

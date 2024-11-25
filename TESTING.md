# Testing

We have two ways of verifying that changes to Flightdeck avoid regressions:

1. We have a [CI workflow] which runs on each pull request and merge. This runs
   Terraform validate and tflint to check for common mistakes and syntax.
2. We have an [acceptance workflow] which runs automatically on the first day of
   each month and can be triggered manually on-demand.

[CI workflow]: https://github.com/thoughtbot/flightdeck/actions/workflows/ci.yaml
[acceptance workflow]: https://github.com/thoughtbot/flightdeck/actions/workflows/acceptance.yaml

## Running Acceptance Tests

You can manually trigger the acceptance workflow from the GitHub Actions UI or
using the [GitHub CLI]. Each branch in the Flightdeck repository will have
independent architecture, and multiple branches can run acceptance
simultaneously.

[GitHub CLI]: https://cli.github.com/

The acceptance workflow will build out the major components of Flightdeck in an
AWS account, run a basic suite of tests, and then tear down the infrastructure.

The Terraform configuration for the test infrastructure is created by cloning
the [Flightdeck template] and [interpolating values] for the test account.

[Flightdeck template]: https://github.com/thoughtbot/flightdeck-template
[interpolating values]: https://github.com/thoughtbot/flightdeck/blob/main/.github/workflows/terraform.yaml

If the acceptance workflow does not complete successfully, the test components
will be left as-is until the workflow runs again and is successful or the
Terraform destroy steps are invoked manually.

## Debugging Acceptance Tests

The Terraform configuration for acceptance workflows is uploaded as an artifact
after each test run. You can download a zip file of the Terraform configuration
from the GitHub Actions UI for a workflow run.

If you are running acceptance tests on a branch, you can invoke the workflow
again to apply any changes in already applied modules and retry failed steps.

## Manually Applying Modules

You can manually apply or destroy one of the Flightdeck Terraform modules from
the acceptance workflow using the [Terraform (Manual) workflow].

1. Click "Run Workflow" from the GitHub Actions UI.
2. Select the branch you want to test.
3. Enter the name of the module you want to apply or destroy:
   - `network/sandbox`
   - `cluster/sandbox-v1`
   - `ingress/sandbox`
   - `platform/sandbox-v1`
4. Select whether you want to run the `apply` or `destroy` command.
5. Click "Run Workflow."

You can view the results of the Terraform run in the GitHub Actions UI, and you
download a copy of the Terraform configuration generated from the workflow's
artifacts.

[Terraform (Manual) workflow]: https://github.com/thoughtbot/flightdeck/actions/workflows/terraform-dispatch.yaml

## Testing Process

Once the network, cluster, ingress, and platform modules have been applied, some
test [manifests] are applied to the cluster and a suite of [bats] tests is run
to verify that the manifests were deployed successfully.

If you want to add an additional check to the test suite, you can modify the
manifests to include something you want to test and [write a new test] to verify
that the manifest applied as expected.

[manifests]: https://github.com/thoughtbot/flightdeck/tree/main/tests/manifests
[bats]: https://bats-core.readthedocs.io/en/stable/
[write a new test]: https://bats-core.readthedocs.io/en/stable/writing-tests.html

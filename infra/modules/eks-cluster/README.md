# EKS Cluster Module

This terraform module will spin up a kubernetes cluster running on Amazon EKS.

## Running module

To run this module, first run `terraform init` to install all the third party providers (only necessary the first time or if any providers are added/changed in the [versions.tf](./versions.tf) file).

Next, you can optionally run `terraform plan` to get a preview of what terraform will execute when running `terraform apply`.

Finally, to create/update resources, run `terraform apply` and enter "yes" in the prompt if you are ok with the proposed plan.

## Configuring local environment

Set environment variable `KUBE_CONFIG_PATH`="~/.kube/config".

Once cluster has been created via `terraform apply` you will need to configure `kubectl`. This can be configured by running the following command in this directory:

```shell
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_id) --profile $AWS_PROFILE
```

where `$AWS_PROFILE` is the [named profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) of the `aws` profile for your AWS development environment.

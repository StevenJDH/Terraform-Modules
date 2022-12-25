# AWS EKS Fargate Logging Module
Amazon EKS on Fargate offers a built-in log router based on Fluent Bit. This means that you don't explicitly run a Fluent Bit container as a sidecar, but Amazon runs it for you. All that you have to do is configure the log router, which this module will do.

## Feature highlights

* Uses the latest Fluent Bit CloudWatch plugin written in C, which offers more performance.
* Creates and associates the needed Fluent Bit IAM policy with an existing Fargate pod execution role.
* Configures parsers, filters, and outputs to delivery pod logs with Kubernetes metadata to CloudWatch.
* Sets the log retention policy on newly created log groups.
* Defines a logical naming strategy for log groups and log streams to simplify reviews.

## Usage

```hcl
module "eks-fargate-cwl-logs" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/eks-fargate-logging?ref=main"

  cluster_name                           = "eks-example-cluster-dev"
  private_fargate_worker_node_subnet_ids = ["subnet-1234abcd",]
  eks_fargate_role_name                  = "eks-fargate-role-example-cluster-dev"
  cloudwatch_log_retention_in_days       = 7
  region                                 = "eu-west-3"

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}
```

## Additional information
After logging is enabled with this module, described pods will contain details similarly to the below:

```bash
...
Annotations:          CapacityProvisioned: 0.25vCPU 0.5GB
                      Logging: LoggingEnabled
                      kubernetes.io/psp: eks.privileged
...
Events:
  Type    Reason          Age   From               Message
  ----    ------          ----  ----               -------
  Normal  LoggingEnabled  80s   fargate-scheduler  Successfully enabled logging for pod 
```

And if the details show something like the below, then this means existing pods need to be restarted so that they can pick up the new logging status.

```bash
...
Annotations:          CapacityProvisioned: 0.25vCPU 0.5GB
                      Logging: LoggingDisabled: LOGGING_CONFIGMAP_NOT_FOUND
                      kubernetes.io/psp: eks.privileged
...
Events:
  Type     Reason           Age        From               Message
  ----     ------           ----       ----               -------
  Warning  LoggingDisabled  <unknown>  fargate-scheduler  
```

Finally, the below is a sample log entry from an NGINX test pod that has been enriched with Kubernetes metadata:

```json
{
    "stream": "stdout",
    "logtag": "F",
    "log": "/docker-entrypoint.sh: Configuration complete; ready for start up",
    "kubernetes": {
        "pod_name": "test",
        "namespace_name": "default",
        "pod_id": "db9e92f1-c4a5-4fb6-a22f-c1c1b9fa5791",
        "labels": {
            "eks.amazonaws.com/fargate-profile": "fargate-profile-default",
            "run": "test"
        },
        "annotations": {
            "CapacityProvisioned": "0.25vCPU 0.5GB",
            "Logging": "LoggingEnabled",
            "kubernetes.io/psp": "eks.privileged"
        },
        "host": "fargate-ip-10-0-2-175.eu-west-3.compute.internal",
        "container_name": "test",
        "docker_id": "62f145ede40f3e837263b510408ad1fdc686465de5c671fe3c260b44754e4348",
        "container_hash": "docker.io/library/nginx@sha256:af447bf7a691a0d24441a7cd16a794f9443d958f956dbd73ba4c078f2873beb1",
        "container_image": "docker.io/library/nginx:latest"
    }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.11 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_fargate_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |
| [aws_iam_policy.fargate-cwl-for-fluent-bit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.fargate-cwl-for-fluent-bit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_config_map_v1.fargate-cwl-for-fluent-bit](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [aws_iam_role.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_retention_in_days"></a> [cloudwatch\_log\_retention\_in\_days](#input\_cloudwatch\_log\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `90` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS Cluster to create. | `string` | n/a | yes |
| <a name="input_eks_fargate_role_name"></a> [eks\_fargate\_role\_name](#input\_eks\_fargate\_role\_name) | The name of the EKS Fargate pod execution role name. | `string` | n/a | yes |
| <a name="input_private_fargate_worker_node_subnet_ids"></a> [private\_fargate\_worker\_node\_subnet\_ids](#input\_private\_fargate\_worker\_node\_subnet\_ids) | Identifiers of private subnets to associate with the EKS Fargate Observability Profile. | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fargate_cwl_for_fluent_bit_policy_arn"></a> [fargate\_cwl\_for\_fluent\_bit\_policy\_arn](#output\_fargate\_cwl\_for\_fluent\_bit\_policy\_arn) | n/a |
| <a name="output_fargate_cwl_for_fluent_bit_policy_id"></a> [fargate\_cwl\_for\_fluent\_bit\_policy\_id](#output\_fargate\_cwl\_for\_fluent\_bit\_policy\_id) | n/a |
<!-- END_TF_DOCS -->
# Ingress NGINX Controller Module

## Feature highlights

* Optional auto association of Ingress NGINX controller load balancer with Route53 A records.
* Free, recognized certificates signed by Amazon and Let's Encrypt with auto verification.
* Load balancer TLS termination with optional Amazon certificate.
* Ingress NGINX controller TLS termination with optional Let's Encrypt certificate.
* Support for Let's Encrypt HTTP01 and DNS01 (supports wildcard) Acme Challenge Types.
* Support for IRSA when using DNS01 challenge type to auto manage Route53 TXT challenges.
* Support for Let's Encrypt Staging and Production endpoints using the latest ACME v2 protocol.
* EKS cluster scoped certificate issuing using Let's Encrypt Cluster Issuer.

## Usage

```hcl
module "ingress-nginx-no-tls" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/ingress-nginx"

  ingress_nginx_version = "4.2.5"
  deploy_ingress_test   = true

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}

module "ingress-nginx-nlb-terminated" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/ingress-nginx"

  ingress_nginx_version      = "4.2.5"
  enable_nlb_termination     = true
  deploy_ingress_test        = true
  enable_https_support       = true
  domain                     = "example.com"
  register_nlb_alias_records = ["example.com", "test.example.com"]

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}

module "ingress-nginx-terminated" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/ingress-nginx"

  ingress_nginx_version          = "4.2.5"
  cert_manager_version           = "1.9.1"
  enable_nlb_termination         = false
  enable_ssl_redirect            = true
  deploy_ingress_test            = true
  enable_https_support           = true
  domain                         = "example.com"
  register_nlb_alias_records     = ["example.com", "test.example.com"]
  letsencrypt_enable_prod_issuer = false # Set to true for properly signed certificate.
  letsencrypt_registration_email = "notify@example.com"

  # Using DNS01 instead of the simpler HTTP01 challenge type just to support
  # wildcard certificates. Requires an IAM OIDC Provider configured for IRSA.
  # https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/irsa
  letsencrypt_enable_dns01_challenge = true
  letsencrypt_oidc_issuer_url        = data.aws_eks_cluster.selected.identity[0].oidc[0].issuer

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}
```

**Note:** After freshly deploying the Ingress NGINX Controller, and waiting a few minutes for the NLB to become ready and DNS records to propagate, routing/DNS might not work. As a workaround, edit the controller service, and flip between `"443"` and `https` or `http` and `tcp` to make the ingress setup re-sync. This should fix the issue within a few minutes.

## Testing the ingress controller
If `deploy_ingress_test` was set to `true`, then test resources such as a Pod (default namespace), an ingress resource, and a service were created with or without HTTPS support depending on the configuration. To test with HTTPS enabled, use `curl https://test.<domain> -vvv`, and without, use `curl http://<nlb url> -vvv`. Using curl avoids false-positives seen when using browsers due to caching. If successful, there should be a NGINX welcome page.

## Helm projects
When working with helm, a similar implementation as below should be used to create the needed ingress and service resources.

**ingress.yaml**

```yaml
{{- if .Values.ingress.enabled -}}
{{- $fullName := include "app.fullname" . -}}
{{- $svcPort := .Values.service.port -}}
{{- if and .Values.ingress.className (not (semverCompare ">=1.18-0" .Capabilities.KubeVersion.GitVersion)) }}
  {{- if not (hasKey .Values.ingress.annotations "kubernetes.io/ingress.class") }}
  {{- $_ := set .Values.ingress.annotations "kubernetes.io/ingress.class" .Values.ingress.className}}
  {{- end }}
{{- end }}
{{- if semverCompare ">=1.19-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1
{{- else if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1beta1
{{- else -}}
apiVersion: extensions/v1beta1
{{- end }}
kind: Ingress
metadata:
  name: {{ $fullName }}
  labels:
    {{- include "app.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if and .Values.ingress.className (semverCompare ">=1.18-0" .Capabilities.KubeVersion.GitVersion) }}
  ingressClassName: {{ .Values.ingress.className }}
  {{- end }}
  {{- if .Values.ingress.tls }}
  tls:
    {{- range .Values.ingress.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
      secretName: {{ .secretName }}
    {{- end }}
  {{- end }}
  rules:
    {{- range .Values.ingress.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ .path }}
            {{- if and .pathType (semverCompare ">=1.18-0" $.Capabilities.KubeVersion.GitVersion) }}
            pathType: {{ .pathType }}
            {{- end }}
            backend:
              {{- if semverCompare ">=1.19-0" $.Capabilities.KubeVersion.GitVersion }}
              service:
                name: {{ $fullName }}
                port:
                  number: {{ $svcPort }}
              {{- else }}
              serviceName: {{ $fullName }}
              servicePort: {{ $svcPort }}
              {{- end }}
          {{- end }}
    {{- end }}
{{- end }}
```

**service.yaml**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "app.fullname" . }}
  labels:
    {{- include "app.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "app.selectorLabels" . | nindent 4 }}
```

**values.yaml**

```yaml
service:
  type: ClusterIP
  port: 80

# Ingress NGINX controller terminated example - HTTP01.
ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-staging"
  hosts:
    - host: test.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: example-com-tls-secret
      hosts:
        - test.example.com
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.6 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.11 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.31.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.6.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.13.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_iam_policy.cert-manager-dns01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cert-manager-dns01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cert-manager-dns01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [helm_release.cert-manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ingress-nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.letsencrypt-issuer](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_ingress_v1.ingress-test](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace_v1.cert-manager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.ingress-nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_pod_v1.ingress-test](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_v1) | resource |
| [kubernetes_service_v1.ingress-test](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1) | resource |
| [random_id.cert-manager-dns01](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_iam_openid_connect_provider.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_lb.ingress-controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_route53_zone.public-zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [kubernetes_service_v1.ingress-controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service_v1) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager_count"></a> [cert\_manager\_count](#input\_cert\_manager\_count) | Sets the number of replicas for Cert Manager. | `number` | `1` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | Default namespace for the Cert Manager. | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of Cert Manager to deploy if latest is not desired or version pinning is needed. | `string` | `"latest"` | no |
| <a name="input_create_cert_manager_namespace"></a> [create\_cert\_manager\_namespace](#input\_create\_cert\_manager\_namespace) | Indicates whether or not to create a namespace for the Cert Manager. | `bool` | `true` | no |
| <a name="input_create_ingress_nginx_namespace"></a> [create\_ingress\_nginx\_namespace](#input\_create\_ingress\_nginx\_namespace) | Indicates whether or not to create a namespace for the Ingress NGINX controller. | `bool` | `true` | no |
| <a name="input_deploy_ingress_test"></a> [deploy\_ingress\_test](#input\_deploy\_ingress\_test) | Deploys test resources to validate if the Ingress NGINX controller setup is working using the a nginx pod that serves up a default web page. When done, make sure to set `deploy_ingress_test` to `false` to cleanup the test resources and avoid additional costs. | `bool` | `false` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain to use for certificate. Must only be the apex part such as example.com. Subdomains will be protected by a wildcard automatically if `enable_nlb_termination` is set to true. | `string` | `null` | no |
| <a name="input_enable_https_support"></a> [enable\_https\_support](#input\_enable\_https\_support) | Indicates whether or not to enable SSL/TLS support. See `enable_nlb_termination` for approach. | `bool` | `false` | no |
| <a name="input_enable_internal_nlb"></a> [enable\_internal\_nlb](#input\_enable\_internal\_nlb) | Indicates whether or not to enable internal-facing load balancer. | `bool` | `false` | no |
| <a name="input_enable_nlb_termination"></a> [enable\_nlb\_termination](#input\_enable\_nlb\_termination) | Indicates whether or not to terminate TLS at the load balancer or not. If set to true, a free Amazon certificate is used, which is the native way of doing it. If set to false, a free Let's Encrypt certificate is used via Cert Manager, which requires using `cert-manager.io/cluster-issuer: letsencrypt-staging OR letsencrypt-prod` in the Ingress resource annotation for staging or prod endpoints along with the ingress TLS block. See [Supported Annotations](https://cert-manager.io/docs/usage/ingress/#supported-annotations) if something more is needed. Both termination approaches require `enable_https_support` to be enabled. | `bool` | `true` | no |
| <a name="input_enable_ssl_redirect"></a> [enable\_ssl\_redirect](#input\_enable\_ssl\_redirect) | Redirects HTTP requests to HTTPS. Applies only to Ingress NGINX controller termination since load balancer termination is currently always redirected using a workaround for AWS. It's recommended to keep this option always enabled when possible. | `bool` | `true` | no |
| <a name="input_ingress_ip"></a> [ingress\_ip](#input\_ingress\_ip) | Used by cloud providers to connect the resulting `LoadBalancer` to a pre-existing static IP. | `string` | `null` | no |
| <a name="input_ingress_nginx_namespace"></a> [ingress\_nginx\_namespace](#input\_ingress\_nginx\_namespace) | Default namespace for the Ingress NGINX controller. | `string` | `"ingress"` | no |
| <a name="input_ingress_nginx_replica_count"></a> [ingress\_nginx\_replica\_count](#input\_ingress\_nginx\_replica\_count) | Sets the number of replicas for Ingress NGINX controller. For minikube setups or to reduce in general, set to 1. | `number` | `2` | no |
| <a name="input_ingress_nginx_version"></a> [ingress\_nginx\_version](#input\_ingress\_nginx\_version) | Version of Ingress NGINX controller to deploy if latest is not desired or version pinning is needed. | `string` | `"latest"` | no |
| <a name="input_letsencrypt_enable_dns01_challenge"></a> [letsencrypt\_enable\_dns01\_challenge](#input\_letsencrypt\_enable\_dns01\_challenge) | Indicates whether or not to use DNS01 challenge type instead of HTTP01 to support wildcard certificates. For more information, see [ACME Challenge Types](https://letsencrypt.org/docs/challenge-types). | `bool` | `false` | no |
| <a name="input_letsencrypt_enable_prod_issuer"></a> [letsencrypt\_enable\_prod\_issuer](#input\_letsencrypt\_enable\_prod\_issuer) | Indicates whether or not to use Staging or Production endpoints for the certificate issuing. The Let's Encrypt production issuer has [very strict rate limits](https://letsencrypt.org/docs/rate-limits). When experimenting and learning, it can be very easy to hit those limits. Because of that risk, start with the Let's Encrypt staging issuer, and once happy that it's working, switch to the production issuer. Any issues, see [Cert Manager Troubleshooting](https://cert-manager.io/docs/troubleshooting). | `bool` | `false` | no |
| <a name="input_letsencrypt_oidc_issuer_url"></a> [letsencrypt\_oidc\_issuer\_url](#input\_letsencrypt\_oidc\_issuer\_url) | Issuer Url of the OpenID Connect identity provider. Requires the [IRSA](https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/irsa) module, or any other means that has created the provider. | `string` | `null` | no |
| <a name="input_letsencrypt_registration_email"></a> [letsencrypt\_registration\_email](#input\_letsencrypt\_registration\_email) | Email address used for ACME registration. | `string` | `null` | no |
| <a name="input_register_nlb_alias_records"></a> [register\_nlb\_alias\_records](#input\_register\_nlb\_alias\_records) | List of alias records to register in AWS Route 53 that will be associated with the Ingress NGINX controller load balancer. | `set(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_dns01_role_arn"></a> [cert\_manager\_dns01\_role\_arn](#output\_cert\_manager\_dns01\_role\_arn) | n/a |
| <a name="output_ingress_controller_nlb_arn"></a> [ingress\_controller\_nlb\_arn](#output\_ingress\_controller\_nlb\_arn) | n/a |
| <a name="output_ingress_controller_nlb_hostname"></a> [ingress\_controller\_nlb\_hostname](#output\_ingress\_controller\_nlb\_hostname) | n/a |
| <a name="output_ingress_controller_nlb_name"></a> [ingress\_controller\_nlb\_name](#output\_ingress\_controller\_nlb\_name) | n/a |
<!-- END_TF_DOCS -->
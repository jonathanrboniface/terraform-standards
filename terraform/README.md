<!-- BEGIN_TF_DOCS -->
# Main title

Everything in this comment block will get extracted.

You can put simple text or complete Markdown content
here. Subsequently if you want to render AsciiDoc format
you can put AsciiDoc compatible content in this comment
block.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.14 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.86.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 3.86.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_dns"></a> [cloud\_dns](#module\_cloud\_dns) | ./modules/cloud_dns | n/a |
| <a name="module_gcs_bucket"></a> [gcs\_bucket](#module\_gcs\_bucket) | ./modules/gcs_buckets | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ./modules/kms_keys | n/a |
| <a name="module_network_private"></a> [network\_private](#module\_network\_private) | ./modules/networks | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_properties"></a> [bucket\_properties](#input\_bucket\_properties) | GCP bucket properties | `list(any)` | `[]` | no |
| <a name="input_cloud_nat_additional_ips"></a> [cloud\_nat\_additional\_ips](#input\_cloud\_nat\_additional\_ips) | Determines the number of additional cloud nat ip addresses to be created. Defaults to 0. | `number` | `0` | no |
| <a name="input_cloud_nat_ip_enable_static"></a> [cloud\_nat\_ip\_enable\_static](#input\_cloud\_nat\_ip\_enable\_static) | Determines whether the NAT Gateway should use a static IP Address or a dynamic address assigned by GCP. Defaults to true. | `bool` | `true` | no |
| <a name="input_cloud_nat_min_ports_per_vm"></a> [cloud\_nat\_min\_ports\_per\_vm](#input\_cloud\_nat\_min\_ports\_per\_vm) | Determines the minium number of ports per vm in the cloud nat configuration. Must be a multiple of 2. Defaults to 1024. | `number` | `1024` | no |
| <a name="input_dns_records"></a> [dns\_records](#input\_dns\_records) | A map of key/value label pairs to create a dns record in a desired zone. | `list(map(string))` | `[]` | no |
| <a name="input_dns_zones"></a> [dns\_zones](#input\_dns\_zones) | A map of key/value label pairs to assign to the dns zones. | `list(map(string))` | `[]` | no |
| <a name="input_env"></a> [env](#input\_env) | The environment being deployed into | `string` | `""` | no |
| <a name="input_env_peers"></a> [env\_peers](#input\_env\_peers) | n/a | <pre>map(object({<br>    env      = string,<br>    bucket   = string,<br>    networks = list(map(string)),<br>  }))</pre> | `null` | no |
| <a name="input_kms_keys"></a> [kms\_keys](#input\_kms\_keys) | List of KMS keys to be created | `list(any)` | <pre>[<br>  {<br>    "component": "cqmapp",<br>    "stack": "cqm"<br>  }<br>]</pre> | no |
| <a name="input_network_prefix"></a> [network\_prefix](#input\_network\_prefix) | Used in naming resources, see locals | `string` | `""` | no |
| <a name="input_org"></a> [org](#input\_org) | name of organization, used for naming resources | `string` | `"other"` | no |
| <a name="input_project"></a> [project](#input\_project) | The project indicates the default GCP project all of your resources will be created in. | `string` | `"anthos-299220"` | no |
| <a name="input_project_group"></a> [project\_group](#input\_project\_group) | The project indicates the default GCP project all of your resources will be created in. | `string` | `"test"` | no |
| <a name="input_project_number"></a> [project\_number](#input\_project\_number) | The project number indicates the default GCP project number all of your resources will be created in. | `number` | `"572882796303"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region will be used to choose the default location for regional resources. Regional resources are spread across several zones. | `string` | `"europe-west2"` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | name of the bucket from which terraform remote state is retrieved | `string` | `""` | no |
| <a name="input_ssl_certificate"></a> [ssl\_certificate](#input\_ssl\_certificate) | The value of the SSL Certificate defined in Terraform Cloud | `string` | `""` | no |
| <a name="input_ssl_private_key"></a> [ssl\_private\_key](#input\_ssl\_private\_key) | The value of the SSL Certificate Key defined in Terraform Cloud | `string` | `""` | no |
| <a name="input_vpc_private_description"></a> [vpc\_private\_description](#input\_vpc\_private\_description) | The description of the private vpc | `string` | `""` | no |
| <a name="input_vpc_private_enable_nat"></a> [vpc\_private\_enable\_nat](#input\_vpc\_private\_enable\_nat) | True to setup nat for outbound traffic on the public VPC | `string` | `false` | no |
| <a name="input_vpc_private_name"></a> [vpc\_private\_name](#input\_vpc\_private\_name) | The name of the private vpc | `string` | `""` | no |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | List of maps holding info about subnets needed in the management vpc | `list(map(string))` | <pre>[<br>  {<br>    "cidr": "10.202.26.0/24",<br>    "name": "app"<br>  }<br>]</pre> | no |
| <a name="input_zones"></a> [zones](#input\_zones) | The list of zones that will be used for the resources. | `list(any)` | <pre>[<br>  "europe-west2-a"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_keyring_name"></a> [kms\_keyring\_name](#output\_kms\_keyring\_name) | n/a |
| <a name="output_kms_keys"></a> [kms\_keys](#output\_kms\_keys) | n/a |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | n/a |
| <a name="output_vpc_private"></a> [vpc\_private](#output\_vpc\_private) | n/a |
<!-- END_TF_DOCS -->
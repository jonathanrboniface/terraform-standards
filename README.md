## Terraform-Best-Practices

### Points to Cover
1. Github Actions & CI/CD Integrations
	- Security and Vulnerability Scanning -> [tfsec](https://github.com/aquasecurity/tfsec-pr-commenter-action) & [checkhov](https://github.com/bridgecrewio/checkov-action)
	- Automating Terraform Documentation -> [terraform-docs](https://github.com/terraform-docs/gh-actions)
	- Terraform fmt and validate checks
	- Semantic Versioning hooks
2. [Directory Structure. Mono VS Multi](https://www.hashicorp.com/blog/terraform-mono-repo-vs-multi-repo-the-great-debate)
3. Terragrunt vs Terraform
4. Terraform vs Terraform Cloud


#### Benefits of Terraform Cloud
1. RBAC 
2. API Integration for third party applications and systems rather than service account/user based.
3. Workspaces are Collections of Infrastructure
4. Sentinel is an embeddable policy as code framework to enable fine-grained, logic-based policy decisions that can be extended to source external information to make decisions.
5. Easily leverage and integrate with Hashicorp Vault


Policy enforcement: With Sentinel, you can assign policy criteria to all Terraform plans before execution. This allows for enforcement such that only modules from the TFE private module registry can be used; this provides greater control over collaboration and adoption of company policy and/or regulatory requirements.


#### Benefits of Terragrunt
1. 


### Features included within the Terraform Modules
1. Terraform resource naming convention
2. Unit Tests
3. Managing Sensitive Data
4. Managing state file changes


# AWS Credentials Walkthrough for Terraform

## Why credentials matter

Terraform does not create AWS resources by itself.

Terraform uses the AWS provider, and the AWS provider needs credentials to call AWS APIs.

When you run:

```bash
terraform plan
terraform apply
```

Terraform needs to know:

- Which AWS account am I using?
- Which user or role am I authenticated as?
- What permissions do I have?
- What region should I deploy to?

---

## Quick credential test

Run:

```bash
aws sts get-caller-identity
```

If credentials work, you will see something like:

```json
{
  "UserId": "...",
  "Account": "...",
  "Arn": "..."
}
```

This command is useful because it confirms:

> The AWS CLI knows who I am.

---

# Common Ways AWS Credentials Are Configured

## Option 1: AWS CLI Profile

A common beginner setup is configuring credentials locally with:

```bash
aws configure
```

This stores credentials in:

```text
~/.aws/credentials
~/.aws/config
```

Terraform can then use the active AWS CLI profile automatically.

---

## Checking the Active AWS Identity

To confirm which AWS account and identity are active:

```bash
aws sts get-caller-identity
```

This is a useful validation step before running Terraform deployments.

---

## Using a Specific AWS Profile

You can view the active AWS profile with:

```bash
echo $AWS_PROFILE
```

You can also temporarily set a profile for Terraform:

```bash
export AWS_PROFILE=personal-terraform
```

Then verify access:

```bash
aws sts get-caller-identity
```

---

## Common Credential Issues

Example error:

```text
Error when retrieving credentials: credentials expired
```

This usually means the AWS CLI credentials or session need to be refreshed.

Credential-related issues are often separate from Terraform configuration issues themselves.

---

## Account and Credential Safety

This project is intended for a personal sandbox AWS account or another approved learning environment.

Avoid deploying learning projects into shared, production, or company-managed AWS accounts unless you have explicit approval.

For safety:

- Use a dedicated AWS CLI profile for this project
- Avoid committing credentials or `terraform.tfvars`
- Avoid committing Terraform state files
- Destroy resources after testing
- Use least-privilege permissions whenever possible

This keeps the project isolated, repeatable, and safe to clean up after testing.

---

## Terraform with a Specific AWS Profile

If needed, you can update `providers.tf` like this:

```hcl
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
```

Then add this to `variables.tf`:

```hcl
variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
}
```

And this to `terraform.tfvars`:

```hcl
aws_profile = "personal-terraform"
```

For beginner learning projects, it is also common to rely on whichever AWS profile is already active in the terminal session.

---

## Common Troubleshooting Steps

### 1. Check current identity

```bash
aws sts get-caller-identity
```

### 2. Check active profile

```bash
echo $AWS_PROFILE
```

### 3. Check AWS config

```bash
aws configure list
```

### 4. Refresh credentials

Reconfigure or refresh the AWS CLI profile if credentials have expired.

### 5. Try again

```bash
aws sts get-caller-identity
```

---

## Key Takeaway

Terraform authentication issues are often related to AWS CLI credentials or active profiles rather than Terraform code itself.

Validating credentials early helps avoid confusing deployment failures later in the Terraform workflow.
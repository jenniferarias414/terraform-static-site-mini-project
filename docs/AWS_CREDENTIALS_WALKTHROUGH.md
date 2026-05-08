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

## What this error means

Example error:

```text
Error when retrieving credentials from custom-process: idf_dev credentials expired
```

This means your AWS CLI is configured to use a credential process/profile named something like `idf_dev`, but the temporary credentials are expired.

The fix is not in Terraform code.

The fix is to refresh or re-authenticate your AWS credentials.

---

## Common ways AWS credentials are configured

### Option 1: AWS CLI access keys

Usually used for personal or sandbox AWS accounts.

```bash
aws configure
```

This stores values in:

```text
~/.aws/credentials
~/.aws/config
```

### Option 2: AWS SSO

Common in companies.

Typical command:

```bash
aws sso login --profile <profile-name>
```

### Option 3: Custom credential process

Some companies use an internal login tool.

The AWS config may contain something like:

```text
credential_process = some-company-auth-command
```

If that process says credentials expired, you usually need to rerun the company login/auth command.

---

## How to see which AWS profile you are using

Run:

```bash
echo $AWS_PROFILE
```

If it prints something like:

```text
idf_dev
```

then AWS CLI is using that profile.

You can also check:

```bash
aws configure list
```

---

## How to test a specific profile

```bash
aws sts get-caller-identity --profile idf_dev
```

If it fails, refresh that profile using your company-approved login method.

---

## Important: personal project vs company account

For this learning project, it is safest to use a personal sandbox AWS account or an approved company dev/sandbox account.

Do not deploy experimental resources into a company account unless you are allowed to.

Also, avoid using broad Administrator permissions in shared/company environments unless that is the approved setup.

---

## Terraform with a specific AWS profile

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
aws_profile = "idf_dev"
```

However, many company environments prefer using environment variables or pipeline-provided credentials instead of hardcoding a profile in Terraform.

For beginner learning, it is usually fine to rely on whichever AWS profile is already active in your terminal.

---

## Common troubleshooting steps

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

For SSO:

```bash
aws sso login --profile <profile-name>
```

For company custom auth:

```bash
# Run your company-approved AWS login command
```

### 5. Try again

```bash
aws sts get-caller-identity
```

---

## Interview explanation

If asked how Terraform authenticates to AWS:

> Terraform uses the AWS provider, and the provider uses AWS credentials from the environment, AWS CLI profiles, SSO, or pipeline credentials. Before running Terraform, I usually validate access with aws sts get-caller-identity so I know which account and role I am deploying with.

If asked what happened when credentials expired:

> The Terraform code was not the issue. The AWS CLI credentials had expired, so the provider could not authenticate. The fix is to refresh the AWS profile or credential process, then rerun the Terraform command.

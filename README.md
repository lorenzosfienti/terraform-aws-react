# Terraform for Hosting React App on AWS

## Introduction

This project utilizes Terraform to provision and manage AWS resources necessary for hosting a React application. It aims to automate the setup of infrastructure in a secure, efficient, and repeatable manner, ensuring that the React application is easily accessible over the web.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Deploy](#deploy)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- Make sure you have installed [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli), [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html#cliv2-mac-prereq), and configured a AWS CLI profile (see doc [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-profiles))

```bash
terraform -help
which aws
aws --version 
aws configure
```

## Configuration

- Create a Bucket S3 (<https://www.terraform.io/docs/language/settings/backends/s3.html>) to store Terraform state. Insert the bucket name in providers.tf instead "terraform-aws-react-state"

- Change the profile name in provider.tf instead "lorenzosfienti" (<https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html>)

- Create a file `terraform.tfvars`:

```bash
region        = "<AWS_REGION>"
project       = "<NAME_OF_PROJECT>"
env           = "<ENVIRONMENT>"
force_destroy = true
```

The variable force_destroy it's indicate if you want force the destroy of bucket even if there are files present.

## Deploy

```bash
terraform init
terraform apply
```

If you want to destroy AWS Stack you can run command:

```bash
terraform destroy
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

If you find this project helpful, please give a :star: or even better buy me a coffee :coffee: :point_down: because I'm a caffeine addict :sweat_smile:

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/lorenzosfienti)

## License

This project is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

variable "region" {
    # The AWS region where the resources will be provisioned.
    # Example: "us-east-1"
}
variable "project" {
    # The name of the project.
    # This variable is used to specify the name of the project.
    # It should be a string value.
}
variable "env" {
    # The environment variable is used to specify the environment in which the infrastructure will be deployed.
    # It can be set to "dev", "test", "stage", or "prod".
}
variable "force_destroy" {
    # Determines whether to force the destruction of the resource when it is removed from Terraform management.
    # If set to true, the resource will be destroyed even if it has a deletion protection enabled.
    # If set to false, the resource will not be destroyed if it has a deletion protection enabled.
    # Default value: false
    default = false
}
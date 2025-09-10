## Providers example


terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "6.12.0"
    }
    azureerm = {
        source = "hashicorp/azurerm"
        version = "4.43.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
    region = "us-east-2"
}
# Configure the Microsoft Azure Provider
provider "azureerm" {
    resource_provider_registrations = "none"
    features {}
}
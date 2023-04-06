terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.57.0"
    }
  }
  required_version = ">= 0.14"

  backend "remote" {
    organization = "k8smm"

    workspaces {
      name = "lts-infra"
    }
  }
}

/**
* ## Project: app-ecs-services
*
* Create services and task definitions for the ECS cluster
*
*/

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "dev_environment" {
  type        = "string"
  description = "Boolean flag for development environments"
  default     = "false"
}

variable "stack_name" {
  type        = "string"
  description = "Unique name for this collection of resources"
  default     = "production"
}

variable "dead_mans_switch_cronitor" {
  type        = "string"
  description = "Cronitor URL we need to constantly hit for the dead mans switch."
  default     = "https://cronitor.link/VfKpim/run"
}

# Resources
# --------------------------------------------------------------

## Providers

terraform {
  required_version = "= 0.11.10"

  backend "s3" {
    bucket = "prometheus-production"
    key    = "app-ecs-services-modular.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  version = "~> 1.17"
  region  = "${var.aws_region}"
}

provider "template" {
  version = "~> 1.0.0"
}

provider "pass" {
  store_dir     = "~/.password-store/re-secrets/observe"
  refresh_store = true
}

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
  default     = "prometheus-production"
}

module "app-ecs-services" {
  source = "../../modules/app-ecs-services"

  dev_environment           = false
  remote_state_bucket       = "${var.remote_state_bucket}"
  stack_name                = "${var.stack_name}"
  dead_mans_switch_cronitor = "${var.dead_mans_switch_cronitor.password}"
}

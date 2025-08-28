# ========================================
# GLOBAL CONFIGURATION
# ========================================

# Provider configuration
variable "aws_region" {
  description = "[REQUIRED] AWS region where resources will be created"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.aws_region))
    error_message = "AWS region must be in valid format (e.g., us-east-1, eu-west-2)."
  }
}

# Common settings
variable "availability_zones" {
  description = "[REQUIRED] List of availability zones to use"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2 && length(var.availability_zones) <= 6
    error_message = "Must specify between 2 and 6 availability zones."
  }
}

variable "project_tags" {
  description = "[REQUIRED] Project tags to apply to all resources"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.project_tags : length(k) <= 128 && length(v) <= 256])
    error_message = "Tag keys must be <= 128 characters and values <= 256 characters."
  }
}

variable "vertical" {
  description = "Business vertical name (e.g., LATAM, EMEA, APAC)"
  type        = string
  default     = "LATAM"

  validation {
    condition     = length(var.vertical) > 0
    error_message = "Vertical name cannot be empty."
  }
}

# ========================================
# VPC CONFIGURATION
# ========================================
variable "vpc_cidr" {
  description = "[REQUIRED] CIDR block for VPC"
  type        = string
  default     = ""

  validation {
    condition     = var.vpc_cidr == "" || can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid CIDR block."
  }
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.private_subnets : can(cidrhost(cidr, 0))])
    error_message = "All private subnet CIDRs must be valid CIDR blocks."
  }
}

variable "create_database_subnets" {
  description = "Create separate database subnets"
  type        = bool
  default     = false
}

variable "database_subnets" {
  description = "List of database subnet CIDRs"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.database_subnets : can(cidrhost(cidr, 0))])
    error_message = "All database subnet CIDRs must be valid CIDR blocks."
  }
}

variable "attach_to_transit_gateway" {
  description = "Attach VPC to Transit Gateway"
  type        = bool
  default     = false
}

variable "transit_gateway_id" {
  description = "ID of existing Transit Gateway to attach to"
  type        = string
  default     = ""

  validation {
    condition     = var.transit_gateway_id == "" || can(regex("^tgw-[a-f0-9]{17}$", var.transit_gateway_id))
    error_message = "Transit Gateway ID must be in the format 'tgw-' followed by 17 hexadecimal characters."
  }
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
}

variable "private_routes" {
    description = "Additional routes for production private route tables"
    type = list(object({
      destination_cidr_block    = string
      gateway_id                = optional(string)
      nat_gateway_id            = optional(string)
      transit_gateway_id        = optional(string)
      vpc_endpoint_id           = optional(string)
      vpc_peering_connection_id = optional(string)
    }))
    default = []
  }

variable "vpc_id_associate" {
  description = "vpc id asociar"
  type        = string
  default = null
}

variable "resolver_rule_id" {
  description = "rule resolver id"
  type        = string
  default = null
}
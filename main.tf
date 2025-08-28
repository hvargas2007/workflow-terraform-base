# ======================================================
# VPC - Con subnets privadas y de base de datos
# ======================================================
module "vpc" {
  source                    = "git::https://github.com/hvargas2007/vpc-workflow-terraform?ref=1.0.0"
  vpc_cidr                  = var.vpc_cidr
  vpc_name                  = "vpc-${var.vertical}-${var.environment}"
  azs                       = var.availability_zones
  private_subnets           = var.private_subnets
  create_database_subnets   = var.create_database_subnets
  database_subnets          = var.database_subnets
  enable_nat_gateway        = false
  enable_dns_hostnames      = true
  enable_dns_support        = true
  project_tags              = var.project_tags
  attach_to_transit_gateway = var.attach_to_transit_gateway
  transit_gateway_id        = var.transit_gateway_id
  private_route_table_additional_routes = var.private_routes
  database_route_table_additional_routes = []
  environment                            = "prod"
  vertical                               = var.vertical
  create_transit_gateway                 = false
}
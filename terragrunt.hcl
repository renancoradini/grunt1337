locals {
  folders     = split("/", path_relative_to_include())
  global_vars = yamldecode(file("global.yaml"))
  env_vars    = yamldecode(file(format("%s/%s/%s", local.folders[0], local.folders[1], "env.yaml")))
  region_vars = yamldecode(file(format("%s/%s", local.folders[0], "region.yaml")))
  common_tags = merge(local.global_vars.tags, local.env_vars.tags, local.region_vars.tags)
}

// terragrunt / us-east-1 / envrenan / env.yaml
// terragrunt / us-east-1 / region.yaml

generate "provider" {
  path      = "auto_provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "aws" {
      region = "${local.region_vars.aws_region}"
      default_tags {
        tags = {
          ${yamlencode(local.common_tags)}
        }
      } 
    }
  EOF
}

#  Saving the local terraform tfstate for sandbox enviroment (CloudGuru testing)

// remote_state {
//   backend = "local"

//   generate = {
//     path      = "backend.tf"
//     if_exists = "overwrite_terragrunt"
//   }
//   config = {
//     path = "${path_relative_to_include()}/terraform.tfstate"

//   }
// }

remote_state {
  backend = "s3"
  config = {
    bucket         = "bucketdenzel-testenumber3"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "state-lock"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
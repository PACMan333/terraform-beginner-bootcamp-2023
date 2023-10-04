terraform {
  required_providers {
   terratowns = {
     source = "local.providers/local/terratowns"
     version = "1.0.0"
   }
  } 
  cloud {
    organization = "PACSoft"
   
    workspaces {
      name = "terra-house-1"
    }
  }

}

provider "terratowns" {
  #endpoint = "https://terratowns.cloud/api"
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid 
  token = var.terratowns_access_token
  #endpoint = var.terratowns_endpoint
  #user_uuid = var.teacherseat_user_uuid
  #token = var.terratowns_access_token
}


module "home_arcanum_hosting" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.arcanum.public_path
  content_version = var.arcanum.content_version
}


resource "terratowns_home" "home" {
  name = "How to play Arcanum in 2023!"
  description = <<DESCRIPTION
Arcanum is a game from 2001 that shipped with alot of bugs.
Modders have removed all the originals making this game really fun
to play (despite that old look graphics). This is my guide that will
show you how to play arcanum without spoiling the plot.
DESCRIPTION
  #domain_name = module.home_arcanum_hosting.domain_name
  domain_name = module.home_arcanum_hosting.domain_name
  #content_version = var.arcanum.content_version
  #domain_name = "3fdq33gz.cloudfront.net"
  town = "missingo"
  content_version = var.arcanum.content_version
}


module "home_payday_hosting" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.payday.public_path
  content_version = var.payday.content_version
}

resource "terratowns_home" "home_payday" {
  name = "Making your own Payday Bars"
  description = <<DESCRIPTION
Since Payday candy bars are really good, I decided I would see how I could make my own Payday bars,
and if they taste good.
DESCRIPTION
  domain_name = module.home_payday_hosting.domain_name
  town = "missingo"
  content_version = var.payday.content_version
}

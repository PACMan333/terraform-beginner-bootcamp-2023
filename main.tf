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


module "home_pecans_hosting" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.pecans.public_path
  content_version = var.pecans.content_version
}


resource "terratowns_home" "home" {
  name = "How to make Pecan Pie Bars"
  description = <<DESCRIPTION
Transform the favorite, rich and gooey Thanksgiving Pecan Pie into an easy, 
shareable bar! These pecan pie bars deliver big on the traditional nutty, 
caramel flavor of a Pecan Pie. You can forget baking two pies, this recipe 
will allow you to feed a whole crowd! Once they are cooked, cut and cool 
them and then dip them in melted chocolate for a decadent holiday treat 
everyone will love.
DESCRIPTION
  #domain_name = module.home_arcanum_hosting.domain_name
  domain_name = module.home_pecans_hosting.domain_name
  #content_version = var.arcanum.content_version
  #domain_name = "3fdq33gz.cloudfront.net"
  town = "cooker-cove"
  content_version = var.pecans.content_version
}

/*
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
*/
provider "aws" {
  region  = "ap-southeast-2"
}

# The provider below is required to handle ACM
provider "aws" {
  alias                   = "us-east-1"
  region                  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "sosnowski-blog-nextjs-terraform-state-965161619314"
    key = "terraform/tfstate"
    dynamodb_table = "sosnowski-blog-nextjs-terraform-state"
    region  = "ap-southeast-2"
  }
}

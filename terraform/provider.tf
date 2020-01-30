terraform {
  backend "s3" {
    key = "motion-video-upload.tfstate"
  }
}

provider "aws" {
  version = "~> 2.46"
}

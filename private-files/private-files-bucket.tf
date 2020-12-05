# This file defines the options and names of the 'private files' bucket which
# I use to store SSH keys etc.

# Specify the versions of providers used.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS provider. Note that to be as explicit as possible, this will
# assume we have a 'dwmkerr' profile.
provider "aws" {
  region  = "ap-southeast-1"
  profile = "dwmkerr"
}

# Create the S3 bucket.
resource "aws_s3_bucket" "dwmkerr_private_files" {
  bucket = "dwmkerr-dotfiles-private"
  acl    = "private"

  # Enable versioning as it would be a bit of a disaster if we lost these files.
  # Note that versioning means that we can always _undelete_ a file.
  versioning {
    enabled  = true
  }

  # The tag is purely used for informational purposes.
  tags = {
    Name    = "dwmkerr-dotfiles-private"
    Project = "dotfiles"
  }

  # Avoid accidental deletion of the bucket.
  lifecycle {
    prevent_destroy = true
  }
}

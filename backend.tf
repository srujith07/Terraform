terraform {
  required_version = ">= 1.10"
  
  backend "s3" {
    bucket         = "my-project-tf-state-20257"
    key            = "my-project-tf-state-20257/dev/terraform.tfstate"
    
    # NOTE: Your profile config shows region = eu-west-1. 
    # Ensure this region matches the region of your S3 bucket.
    region         = "eu-west-1" 
    
    encrypt        = true
    use_lockfile   = true
    
    # REQUIRED FIX: Explicitly specify the profile name.
    profile        = "dev" 
  }
}

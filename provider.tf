### 
### Setup the provider.  See README.md for more
### deets on the credentials file.
### 

provider "aws" {
  shared_credentials_file = "${var.cred_file}"
  profile                 = "${var.cred_profile}"
  region                  = "us-east-1"
}

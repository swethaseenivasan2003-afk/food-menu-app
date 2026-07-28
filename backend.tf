terraform {
  backend "s3" {
    bucket       = "mybucket-swetharohanirkullawar-2205"
    key          = "food-menu-app/terraform.tfstate"
    region       = "ap-south-2"
    use_lockfile = true
  }
}
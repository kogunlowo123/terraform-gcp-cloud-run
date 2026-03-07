module "cloud_run" {
  source = "../../"

  project_id = "my-gcp-project"
  region     = "us-central1"

  services = {
    "my-api" = {
      image                 = "gcr.io/my-gcp-project/my-api:latest"
      port                  = 8080
      allow_unauthenticated = true
      env_vars = {
        ENV = "dev"
      }
    }
  }

  labels = {
    environment = "dev"
  }
}

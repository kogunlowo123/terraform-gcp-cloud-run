module "test" {
  source = "../"

  project_id = "test-project-id"
  region     = "us-central1"

  labels = {
    environment = "test"
    managed_by  = "terraform"
  }

  services = {
    api-service = {
      image              = "us-docker.pkg.dev/cloudrun/container/hello:latest"
      port               = 8080
      cpu                = "1000m"
      memory             = "512Mi"
      min_instance_count = 0
      max_instance_count = 10
      timeout            = "300s"
      ingress            = "INGRESS_TRAFFIC_ALL"

      env_vars = {
        APP_ENV  = "test"
        LOG_LEVEL = "info"
      }

      allow_unauthenticated = false

      labels = {
        service = "api"
      }
    }
  }

  jobs = {
    data-processor = {
      image       = "us-docker.pkg.dev/cloudrun/container/hello:latest"
      cpu         = "1000m"
      memory      = "1Gi"
      task_count  = 1
      max_retries = 3
      timeout     = "600s"

      env_vars = {
        JOB_TYPE = "batch-process"
      }

      labels = {
        job = "data-processor"
      }
    }
  }
}

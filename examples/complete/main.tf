module "cloud_run" {
  source = "../../"

  project_id = "my-gcp-project"
  region     = "us-central1"

  # VPC Connectors
  vpc_connectors = {
    "my-vpc-connector" = {
      network       = "default"
      ip_cidr_range = "10.8.0.0/28"
      min_instances = 2
      max_instances = 5
      machine_type  = "e2-micro"
    }
  }

  # Cloud Run Services
  services = {
    "api-service" = {
      image              = "gcr.io/my-gcp-project/api:latest"
      port               = 8080
      cpu                = "2000m"
      memory             = "1Gi"
      min_instance_count = 1
      max_instance_count = 50
      ingress            = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
      service_account    = "api-sa@my-gcp-project.iam.gserviceaccount.com"
      allow_unauthenticated = false
      env_vars = {
        ENV       = "production"
        LOG_LEVEL = "info"
      }
      secret_env_vars = {
        DB_PASSWORD = {
          secret  = "projects/my-gcp-project/secrets/db-password"
          version = "latest"
        }
      }
      vpc_connector = "my-vpc-connector"
      vpc_egress    = "ALL_TRAFFIC"
    }

    "web-frontend" = {
      image                 = "gcr.io/my-gcp-project/web:latest"
      port                  = 3000
      allow_unauthenticated = true
      min_instance_count    = 1
      max_instance_count    = 20
    }
  }

  # Cloud Run Jobs
  jobs = {
    "data-migration" = {
      image           = "gcr.io/my-gcp-project/migration:latest"
      cpu             = "2000m"
      memory          = "2Gi"
      task_count      = 1
      max_retries     = 3
      timeout         = "1800s"
      service_account = "migration-sa@my-gcp-project.iam.gserviceaccount.com"
      env_vars = {
        TARGET_DB = "production"
      }
    }
  }

  labels = {
    environment = "production"
    team        = "platform"
  }
}

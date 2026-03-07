# ---------------------------------------------------------------------------------------------------------------------
# VPC Access Connectors
# ---------------------------------------------------------------------------------------------------------------------
resource "google_vpc_access_connector" "this" {
  for_each = var.vpc_connectors

  project       = var.project_id
  name          = each.key
  region        = var.region
  network       = each.value.network
  ip_cidr_range = each.value.ip_cidr_range
  machine_type  = each.value.machine_type
  min_instances = each.value.min_instances
  max_instances = each.value.max_instances

  min_throughput = each.value.min_throughput
  max_throughput = each.value.max_throughput
}

# ---------------------------------------------------------------------------------------------------------------------
# Cloud Run v2 Services
# ---------------------------------------------------------------------------------------------------------------------
resource "google_cloud_run_v2_service" "this" {
  for_each = var.services

  project  = var.project_id
  name     = each.key
  location = var.region
  ingress  = each.value.ingress
  labels   = merge(local.default_labels, each.value.labels)

  template {
    service_account                  = each.value.service_account
    timeout                          = each.value.timeout
    execution_environment            = each.value.execution_environment
    max_instance_request_concurrency = 80

    scaling {
      min_instance_count = each.value.min_instance_count
      max_instance_count = each.value.max_instance_count
    }

    dynamic "vpc_access" {
      for_each = each.value.vpc_connector != null ? [1] : []
      content {
        connector = each.value.vpc_connector
        egress    = each.value.vpc_egress
      }
    }

    containers {
      image = each.value.image

      ports {
        container_port = each.value.port
      }

      resources {
        limits = {
          cpu    = each.value.cpu
          memory = each.value.memory
        }
      }

      dynamic "env" {
        for_each = each.value.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "env" {
        for_each = each.value.secret_env_vars
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = env.value.secret
              version = env.value.version
            }
          }
        }
      }
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Cloud Run IAM - Allow unauthenticated access
# ---------------------------------------------------------------------------------------------------------------------
resource "google_cloud_run_service_iam_member" "allow_unauthenticated" {
  for_each = { for k, v in var.services : k => v if v.allow_unauthenticated }

  project  = var.project_id
  location = var.region
  service  = google_cloud_run_v2_service.this[each.key].name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# ---------------------------------------------------------------------------------------------------------------------
# Cloud Run v2 Jobs
# ---------------------------------------------------------------------------------------------------------------------
resource "google_cloud_run_v2_job" "this" {
  for_each = var.jobs

  project  = var.project_id
  name     = each.key
  location = var.region
  labels   = merge(local.default_labels, each.value.labels)

  template {
    task_count  = each.value.task_count
    parallelism = each.value.task_count

    template {
      service_account = each.value.service_account
      timeout         = each.value.timeout
      max_retries     = each.value.max_retries

      dynamic "vpc_access" {
        for_each = each.value.vpc_connector != null ? [1] : []
        content {
          connector = each.value.vpc_connector
        }
      }

      containers {
        image = each.value.image

        resources {
          limits = {
            cpu    = each.value.cpu
            memory = each.value.memory
          }
        }

        dynamic "env" {
          for_each = each.value.env_vars
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
  }
}

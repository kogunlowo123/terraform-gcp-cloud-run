locals {
  default_labels = merge(var.labels, {
    managed_by = "terraform"
    module     = "cloud-run"
  })
}

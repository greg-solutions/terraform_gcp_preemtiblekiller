locals {
  name = "preemptible-killer"
}
locals {
  name_id = "preemptible_killer"
}

locals {
  helm_repo_url = "https://helm.estafette.io"
}

locals {
  helm_repo_name = "estafette"
}

locals {
  helm_chart = "estafette-gke-preemptible-killer"
}

locals {
  helm_template_version = "1.2.5"
}

variable "whitelist_hours" {
  description = "(Optional) List of UTC time intervals in which deletion is allowed and preferred"
  default = []
}

variable "blacklist_hours" {
  description = "(Optional) List of UTC time intervals in which deletion is NOT allowed"
  default = []
}

variable "drain_timeout" {
  description = "(Optional) Max time in second to wait before deleting a node"
  default = "300"
}

variable "interval_checks" {
  description = "(Optional) Time in second to wait between each node check"
  default = "600"
}
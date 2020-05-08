locals {
  name = "preemptible-killer"
  name_id = "preemptible_killer"
  helm_repo_name = "estafette"
  helm_chart = "estafette-gke-preemptible-killer"
  helm_template_version = "1.2.5"
}

variable "whitelist_hours" {
  type = list(string)
  description = "(Optional) List of UTC time intervals in which deletion is allowed and preferred"
  default = []
}
variable "blacklist_hours" {
  type = list(string)
  description = "(Optional) List of UTC time intervals in which deletion is NOT allowed"
  default = []
}
variable "drain_timeout" {
  type = string
  description = "(Optional) Max time in second to wait before deleting a node"
  default = "300"
}
variable "interval_checks" {
  type = string
  description = "(Optional) Time in second to wait between each node check"
  default = "600"
}
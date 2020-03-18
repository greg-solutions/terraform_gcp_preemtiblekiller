resource "google_service_account" "service-account" {
  account_id   = local.name
  display_name = local.name
}

resource "google_project_iam_custom_role" "iam-role" {
  role_id     = local.name_id
  title       = local.name
  description = "Delete compute instances"
  permissions = ["compute.instances.delete"]
}

resource "google_project_iam_binding" "role_to_project" {
  members = ["serviceAccount:${google_service_account.service-account.email}",]
  role = google_project_iam_custom_role.iam-role.id
}

resource "google_service_account_key" "key" {
  service_account_id = google_service_account.service-account.name
  private_key_type    = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = {
      name = local.helm_repo_name
    }
    name = local.helm_repo_name
  }
}

resource "helm_release" "application" {
  chart = local.helm_chart
  repository = data.helm_repository.estafette.metadata[0].name
  name = local.helm_chart
  namespace = kubernetes_namespace.namespace.id
  recreate_pods = true
  force_update = true
  version = local.helm_template_version
  dynamic "set" {
    iterator = time
    for_each = var.whitelist_hours
    content {
      name = "extraEnv.WHITELIST_HOURS"
      value = replace(time.value, ",", "\\,")
    }
  }
  dynamic "set" {
    iterator = time
    for_each = var.blacklist_hours
    content {
      name = "extraEnv.BLACKLIST_HOURS"
      value = replace(time.value, ",", "\\,")
    }
  }
  set {
  name = "drainTimeout"
  value = var.drain_timeout
  }
  set {
    name = "interval"
    value = var.interval_checks
  }
  set {
    name = "secret.valuesAreBase64Encoded"
    value = true
  }
  set {
    name = "secret.googleServiceAccountKeyfileJson"
    value = google_service_account_key.key.private_key
  }
}
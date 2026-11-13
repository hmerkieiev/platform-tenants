variable "name" {
  description = "Tenant name. The namespace is tenant-<name>. A reserved platform name is rejected."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{2,15}$", var.name))
    error_message = "name must be a short lowercase word."
  }

  validation {
    condition = !contains([
      "internal",
      "default",
      "platform",
      "kube-system",
      "kube-public",
      "kube-node-lease",
      "traefik",
      "calico-system",
      "argocd",
    ], var.name)
    error_message = "that name is reserved by the platform."
  }
}

variable "host" {
  description = "Public host for this tenant. It stays under demo.test."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+\\.demo\\.test$", var.host))
    error_message = "host must be under demo.test."
  }
}

variable "image" {
  description = "Pinned image. The tag latest is not a release."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9._/-]*:[A-Za-z0-9][A-Za-z0-9._-]*$", var.image)) && !endswith(var.image, ":latest")
    error_message = "image needs a pinned tag other than latest."
  }
}

variable "quota" {
  description = "Pods, CPU, and memory the tenant chart will enforce."
  type = object({
    pods   = string
    cpu    = string
    memory = string
  })

  validation {
    condition = (
      can(regex("^[1-9][0-9]*$", var.quota.pods))
      && tonumber(var.quota.pods) >= 2
      && tonumber(var.quota.pods) <= 10
      && can(regex("^[1-9][0-9]*m$", var.quota.cpu))
      && tonumber(trimsuffix(var.quota.cpu, "m")) >= 200
      && tonumber(trimsuffix(var.quota.cpu, "m")) <= 2000
      && can(regex("^[1-9][0-9]*Mi$", var.quota.memory))
      && tonumber(trimsuffix(var.quota.memory, "Mi")) >= 128
      && tonumber(trimsuffix(var.quota.memory, "Mi")) <= 1024
    )
    error_message = "quota must stay inside the platform floor and ceiling."
  }
}

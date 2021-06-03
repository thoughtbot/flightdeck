variable "enable_github_webhook" {
  type        = bool
  description = "Set to false to disable the GitHub webhook"
  default     = true
}

variable "github_access_token_parameter" {
  type        = string
  description = "Personal OAuth2 token capable of managing pull requests"
}

variable "github_repository_name" {
  type        = string
  description = "Owner and name of the GitHub repository to deploy"
}

variable "github_deploy_branches" {
  type        = list(string)
  description = "Name of branches for auto-deploy"
  default     = ["main"]
}

variable "name" {
  type        = string
  description = "Name for this CodeBuild project"
}

variable "namespace" {
  type        = list(string)
  default     = []
  description = "Prefix to be applied to created resources"
}

variable "report_build_status" {
  type        = bool
  description = "Set to false to disable adding status to pull requests"
  default     = true
}

variable "scripts" {
  type        = list(object({ policies = list(string), shell = string }))
  description = "Shell scripts which should be executed to deploy"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to created resources"
  default     = {}
}

variable "base_image" {
  type        = string
  description = "Base image for this Docker build"
}

variable "build_args" {
  type        = list(string)
  description = "Extra arguments to pass to Docker build"
  default     = []
}

variable "dockerfile" {
  type        = string
  description = "Location of the Dockerfile within the repository"
  default     = "Dockerfile"
}

variable "name" {
  type        = string
  description = "Unprefixed name for created resources"
  default     = "build"
}

variable "namespace" {
  type        = list(string)
  default     = []
  description = "Prefix to be applied to created resources"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to created resources"
  default     = {}
}

variable "repository" {
  type        = object({ arn = string, name = string })
  description = "ECR repository to which Docker images should be pushed"
}

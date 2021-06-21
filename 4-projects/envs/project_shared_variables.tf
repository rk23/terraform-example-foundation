variable "parent_folder" {
  description = "Optional if using a folder for testing"
  type        = string
  default     = ""
}

variable "budget_amount" {
  description = "The amount to budget for project"
  type        = number
  default     = 20
}
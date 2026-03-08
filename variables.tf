variable "image_name" {
  type    = string
  default = "nginx:latest"
}
variable "client_image_name" {
  type    = string
  default = "appropriate/curl"
}
variable "client_container_name" {
  type    = string
  default = "client-terraform"
}
variable "container_name" {
  type    = string
  default = "nginx-terraform"
}
variable "container_port" {
  type    = number
  default = 80
}
variable "container_external_port" {
  type    = number
  default = 8080
}
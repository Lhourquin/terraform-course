terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }
}
provider "docker" {}

resource "docker_network" "app" {
  name = "app_network"
}

resource "docker_image" "nginx" {
  name         = var.image_name
  keep_locally = true
}
resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  ports {
    internal = var.container_port
    external = var.container_external_port
  }

  networks_advanced {
    name = docker_network.app.name
  }
}
output "nginx_container_id" {
  value = docker_container.nginx.id
}
resource "terraform_data" "nginx_test" {
  depends_on = [docker_container.nginx]

  provisioner "local-exec" {
    command = "sleep 3 && curl -sk 'https://${var.container_name}.orb.local/' | grep -q 'Welcome' || (echo 'La réponse ne contient pas Welcome' && exit 1)"
  }
}

resource "docker_container" "client" {
  name  = var.client_container_name
  image = var.client_image_name

  command = ["sleep", "infinity"]

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = docker_network.app.name
  }
}
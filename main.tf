terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "~> 2.23.0"
        }
    }
}

provider "docker" {}

resource "docker_image" "nginx" {
    name = "nginx-img"
    keep_locally = false
    build {
        path  = "./"        
    }
}

resource "docker_container" "nginx" {
    name  = "nginx-cnt"
    image = docker_image.nginx.image_id
    ports {
        internal = 80
        external = 8080
    }
}

variable "db_root_password" {
    type = string
}

resource "docker_container" "db" {
    name  = "db"
    image = "mariadb:latest"
    restart = "always"    
    env = [
        "MYSQL_ROOT_PASSWORD=${var.db_root_password}",
        "MYSQL_PASSWORD=password",
        "MYSQL_USER=user",
        "MYSQL_DATABASE=database"
    ]
    ports {
        internal = 3306
        external = 3306
    }  
}
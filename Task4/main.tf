terraform {
  required_version = ">= 1.0"
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.75.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = "${path.module}/sa_key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_vpc_network" "network" {
  name = "main-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "main-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = [var.subnet_cidr]
}

data "yandex_vpc_security_group" "sg" {
  name      = "default-sg-enpj0c2jo31p46sfo22i"
  folder_id = var.folder_id
}

resource "yandex_compute_instance" "data_platform" {
  name = "data-platform"

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 50
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = true
    security_group_ids = [data.yandex_vpc_security_group.sg.id]
  }
}

resource "yandex_compute_instance" "kafka" {
  name = "kafka"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 30
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = true
    security_group_ids = [data.yandex_vpc_security_group.sg.id]
  }
}

resource "yandex_compute_instance" "bi" {
  name = "bi"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 30
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = true
    security_group_ids = [data.yandex_vpc_security_group.sg.id]
  }
}
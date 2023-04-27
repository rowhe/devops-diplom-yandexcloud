terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "diploma-tf-bucket"
    region     = "ru-central1"
#    key        = "terraform/main.tfstate"
    token      = "var.yc_token"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token		= var.yc_token
  cloud_id	= var.yc_cloud_id
  zone		= var.yc_region_a
  folder_id	= var.yc_folder_id
}

resource "yandex_vpc_network" "diploma_network" {
  name = "diploma-net"
}

resource "yandex_vpc_subnet" "subnet10_1" {
  v4_cidr_blocks = ["10.1.0.0/16"]
  zone           = var.yc_region_a
  network_id     = yandex_vpc_network.diploma_network.id
}

resource "yandex_vpc_subnet" "subnet10_2" {
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = var.yc_region_b
  network_id     = yandex_vpc_network.diploma_network.id
}

resource "yandex_compute_image" "my_image" {
  description	= "Test image"
#  source_family	= "ubuntu-2004-lts"
#  source_image = "fd81hgrcv6lsnkremf32"
  source_image = "fd8g89v5520br3460363"
  folder_id	= var.yc_folder_id
  min_disk_size	= 10
  os_type	= "linux"
}

locals {
  instance = {
    default	= 0
    prod	= 2
    stage	= 1
  }
}

resource "yandex_compute_instance" "master1" {
  name = "cp1-${count.index}-${terraform.workspace}"
#  zone = "ru-central1-a"
  zone = var.yc_region_a
  hostname = "cp1-${count.index}-${terraform.workspace}"

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id	= yandex_compute_image.my_image.id
      size	= 25
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet10_1.id
    nat = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("./ssh/id_rsa.pub")}"
  }

#  connection {
#      type        = "ssh"
#      host        = self.public_ip
#      user        = "dpopov"
#      private_key = file("~/.ssh/id_rsa")
#      timeout     = "4m"
#   }
  count 	= local.instance[terraform.workspace]
}

resource "yandex_compute_instance" "master2" {
  name = "cp2-${count.index}-${terraform.workspace}"
#  zone = "ru-central1-a"
  zone = var.yc_region_b
  hostname = "cp2-${count.index}-${terraform.workspace}"

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id	= yandex_compute_image.my_image.id
      size	= 25
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet10_2.id
    nat = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("./ssh/id_rsa.pub")}"
  }

#  connection {
#      type        = "ssh"
#      host        = self.public_ip
#      user        = "dpopov"
#      private_key = file("~/.ssh/id_rsa")
#      timeout     = "4m"
#   }
  count 	= local.instance[terraform.workspace]
}

locals {
  id_2 = toset([
  "b0",
  "b1",
  ])
}

resource "yandex_compute_instance" "node2" {
  for_each = local.id_2
  name = "node-${each.key}-${terraform.workspace}"
  zone = var.yc_region_b
  hostname = "node-${each.key}-${terraform.workspace}"

  lifecycle {
    create_before_destroy = true
    }
  resources {
    cores = 2
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.my_image.id
      size = 25
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet10_2.id
    nat = true
  }

  metadata = {
#    ssh_keys = "ubuntu:${file("./ssh/id_rsa.pub")}"
    ssh-keys = "${var.ssh_user}:${file("./ssh/id_rsa.pub")}"
  }
}

locals {
  id_1 = toset([
  "a0",
  "a1",
  ])
}

resource "yandex_compute_instance" "node1" {

  for_each	= local.id_1
  name		= "node-${each.key}-${terraform.workspace}"
  zone = var.yc_region_a
  hostname = "node-${each.key}-${terraform.workspace}"
  
  lifecycle {
    create_before_destroy = true
  }
  
  resources {
    cores	= 2
    memory	= 4
  }
  
  boot_disk {
    initialize_params {
      image_id	= yandex_compute_image.my_image.id
      size = 25
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet10_1.id
    nat		= true
  }
  
  metadata = {
#    ssh-keys = "ubuntu:${file("./ssh/id_rsa.pub")}"
    ssh-keys = "${var.ssh_user}:${file("./ssh/id_rsa.pub")}"
  }
}

//// Create SA
//resource "yandex_iam_service_account" "sa" {
//  folder_id = "${var.yc_folder_id}"
//  name      = "tf-test-sa"
//}
//
//// Grant permissions
//resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
//  folder_id = "${var.yc_folder_id}"
//  role      = "admin"
////  role      = "storage.editor"
//  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
//}
//
//// Create Static Access Keys
//resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
//  service_account_id = yandex_iam_service_account.sa.id
//  description        = "static access key for object storage"
//}
//
//// Use keys to create bucket
//resource "yandex_storage_bucket" "diploma-bucket" {
//  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
//  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
//  bucket = "bigbucket"
//}

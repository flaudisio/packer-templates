# ------------------------------------------------------------------------------
# LOCALS
# ------------------------------------------------------------------------------

locals {
  timestamp = formatdate("YYYYMMDD-hhmmss-ZZZ", timestamp())

  image_name = format("gitlab-runner_ubuntu1804_%s.packer", local.timestamp)

  aws_ami_description = var.image_description
  aws_ami_name        = local.image_name

  digitalocean_snapshot_name = local.image_name
}

# ------------------------------------------------------------------------------
# DATA SOURCES
# ------------------------------------------------------------------------------

data "amazon-ami" "selected" {
  region      = var.aws_region
  most_recent = true

  owners = [var.aws_source_ami_owners]

  filters = {
    architecture        = var.aws_source_ami_architecture
    name                = var.aws_source_ami_filter_name
    root-device-type    = "ebs"
    state               = "available"
    virtualization-type = "hvm"
  }
}

# ------------------------------------------------------------------------------
# SOURCES
# ------------------------------------------------------------------------------

source "amazon-ebs" "main" {
  ami_description             = local.aws_ami_description
  ami_name                    = local.aws_ami_name
  associate_public_ip_address = true
  instance_type               = var.aws_instance_type
  region                      = var.aws_region
  run_tags = {
    Name                = "Packer Builder - ${local.aws_ami_name}"
    "packer/created-by" = var.creator
  }
  source_ami   = data.amazon-ami.selected.id
  ssh_username = var.aws_ssh_username
  subnet_id    = var.aws_subnet_id
  tags = {
    Name                      = local.aws_ami_name
    "packer/created-at"       = legacy_isotime("20060102-150405")
    "packer/created-by"       = var.creator
    "packer/packer-version"   = packer.version
    "packer/source-ami-name"  = data.amazon-ami.selected.name
    "packer/source-ami-owner" = data.amazon-ami.selected.owner
  }
}

source "digitalocean" "main" {
  image         = var.digitalocean_image
  region        = var.digitalocean_region
  size          = var.digitalocean_size
  snapshot_name = local.digitalocean_snapshot_name
  ssh_username  = var.digitalocean_ssh_username
  tags          = var.digitalocean_tags
}

# ------------------------------------------------------------------------------
# BUILDS
# ------------------------------------------------------------------------------

build {
  sources = [
    "source.amazon-ebs.main",
    "source.digitalocean.main",
  ]

  provisioner "shell" {
    scripts = [
      "../_scripts/wait-cloud-init.sh",
      "../_scripts/apt-upgrade.sh",
    ]
  }

  provisioner "ansible" {
    extra_arguments      = ["-v"]
    playbook_file        = "ansible/playbook.yml"
    galaxy_file          = "ansible/requirements.yml"
    galaxy_force_install = true
  }

  provisioner "shell" {
    inline = [
      "sudo curl -L -o /usr/local/bin/docker-machine https://github.com/docker/machine/releases/download/v${var.docker_machine_version}/docker-machine-$( uname -s )-$( uname -m )",
      "sudo chmod -v 755 /usr/local/bin/docker-machine",
    ]
  }

  provisioner "shell" {
    inline = [
      "curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash",
      "sudo apt install gitlab-runner=${var.gitlab_runner_version}",
      "sudo systemctl enable gitlab-runner",
    ]
  }
}

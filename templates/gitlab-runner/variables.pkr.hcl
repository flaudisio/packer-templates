variable "aws_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_source_ami_architecture" {
  type    = string
  default = "x86_64"
}

variable "aws_source_ami_filter_name" {
  type    = string
  default = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
}

variable "aws_source_ami_id" {
  type    = string
  default = ""
}

variable "aws_source_ami_owners" {
  type    = string
  default = "099720109477"
}

variable "aws_ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "aws_subnet_id" {
  type    = string
  default = ""
}

variable "creator" {
  type    = string
  default = "Packer"
}

variable "digitalocean_image" {
  type    = string
  default = "ubuntu-18-04-x64"
}

variable "digitalocean_region" {
  type    = string
  default = "nyc3"
}

variable "digitalocean_size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "digitalocean_ssh_username" {
  type    = string
  default = "root"
}

variable "digitalocean_tags" {
  type    = list(string)
  default = ["packer-created", "ci-cd"]
}

variable "docker_machine_version" {
  type    = string
  default = "0.16.2"
}

variable "gitlab_runner_version" {
  type    = string
  default = "12.4.1"
}

variable "image_description" {
  type    = string
  default = "GitLab Runner on Ubuntu 18.04"
}

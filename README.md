# Packer Templates

[Packer](https://packer.io/intro/index.html) templates to create cloud images.

## Requirements

- Packer >= 1.7.0
- Ansible >= 2.8

## Usage

Clone the repository:

```console
$ git clone https://github.com/flaudisio/packer-templates.git

$ cd packer-templates/
```

Choose a template and set credentials according to its builders:

```console
$ cd templates/gitlab-runner/

$ export AWS_ACCESS_KEY_ID=<ACCESS_KEY>
$ export AWS_SECRET_ACCESS_KEY=<SECRET_KEY>
$ export DIGITALOCEAN_API_TOKEN=<API_TOKEN>
```

Validate and build the images!

```console
$ packer validate .
$ packer build .
```

If applicable, use `-only` to build specific images:

```console
$ packer validate -only aws .
$ packer build -only amazon-ebs.main .
$ packer build -only digitalocean.main .
```

## License

[MIT](LICENSE).

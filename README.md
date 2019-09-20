# Packer Templates

[Packer](https://packer.io/intro/index.html) templates to create some ready-to-use images.

## Requirements

- Packer 1.4.0+
- Ansible 2.8+

## Usage

Clone the repository:

```console
$ git clone git@gitlab.com:ftolentino/packer-templates.git

$ cd packer-templates/
```

Choose a template and set credentials according to its builders:

```console
$ cd templates/gitlab-runner/

$ export AWS_ACCESS_KEY_ID=<ACCESS_KEY>
$ export AWS_SECRET_ACCESS_KEY=<SECRET_KEY>
$ export DIGITALOCEAN_API_TOKEN=<API_TOKEN>
```

Validate & build the image!

```console
$ packer validate template.json
$ packer build template.json
```

If applicable, use `-only` to build a specific image:

```console
$ packer validate -only=amazon-ebs template.json
$ packer build -only=amazon-ebs template.json
```

## License

[MIT](LICENSE).

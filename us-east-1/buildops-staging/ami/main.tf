data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240301"]
  }
}

output "id" {
  value = data.aws_ami.ubuntu.id
}

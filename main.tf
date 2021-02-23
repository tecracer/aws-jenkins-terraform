provider "aws" {
  profile = "default"
  region  = "us-west-2"
}


data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

resource "aws_instance" "jenkins" {
  ami = data.aws_ami.amazon-linux-2.id
  instance_type = "t3.micro"
  security_groups = [aws_security_group.web_traffic.name]
  key_name = "labkey"
  user_data = file("userdata/jenkins.sh")
  iam_instance_profile = "JenkinsProfile"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("labkey.pem")
  }

  tags = {
    "Name"      = "Jenkins_Server"
    "Terraform" = "true"
  }
}

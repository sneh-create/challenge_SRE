resource "aws_key_pair" "my_key" {
  key_name = "tf-key"
  public_key = file("tf-key.pub")
}
resource "aws_default_vpc" "default" {
  
}
resource "aws_security_group" "my_security_group" {
    name = "my_sg_1"
    description = "securtiy group by tf"
    vpc_id = aws_default_vpc.default.id
    ingress {
        description = "inbound rules 22"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "inbound rules 80"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "outbound rules"
        to_port = 0
        from_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
       name = "my_sg_1"
    }
}

resource "aws_instance" "my_instance" {
    instance_type = "t2.micro"
    security_groups = [ aws_security_group.my_security_group.name ]
    key_name = aws_key_pair.my_key.key_name
    ami = "ami-053b12d3152c0cc71"
    root_block_device {
      volume_size = 10
      volume_type = "gp3"
    }
    tags = {
        Name = "tfubuntu"
    }
    user_data = file("install.sh")
    #user_data = <<-EOF
    #!/bin/bash
    #sudo apt-get update -y
    #sudo apt-get install docker.io -y
    #sudo usermod -aG docker ubuntu
    #echo "Docker installation completed successfully." >> /var/log/user-data.log 2>&1
  #EOF
}


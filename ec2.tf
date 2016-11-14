resource "aws_security_group" "gaming_ec2" {
  name        = "inbound_rdp"
  description = "Inbound rdp from home"
  vpc_id      = "${aws_vpc.gaming.id}"

  ingress {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = ["100.36.177.107/32"]
  }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "inbound_rdp" {
  name        = "inbound_rdp"
  description = "Inbound rdp from defined network"
  vpc_id      = "${aws_vpc.gaming.id}"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_block_srcnet}"]
  }
}

resource "aws_security_group" "outbound_all" {
  name        = "outbound_all"
  description = "Allow all outbound traffic"
  vpc_id      = "${aws_vpc.gaming.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "gaming_key" {
  key_name = "gaming_key"
  public_key = "${var.gaming_key_public}"
}

resource "aws_instance" "gaming_pc" {
  ami                         = "${var.gaming_win_ami}"
  instance_type               = "g2.2xlarge"
  subnet_id                   = "${aws_subnet.public.id}"
  associate_public_ip_address = "true"
  vpc_security_group_ids      = ["${aws_security_group.inbound_rdp.id}", "${aws_security_group.outbound_all.id}"]
  key_name                    = "${aws_key_pair.gaming_key.key_name}"

  tags {
    Name = "Gaming PC"
  }
}

###
### Setup the vpc, subnets, and internet gateway.
### All the networks are defined in variables.tf,
### see README.md for more info.  You should not
### need to modify anything in here.
###

resource "aws_vpc" "gaming" {
  cidr_block = "${var.cidr_block_vpc}"

  tags {
    Name = "gaming_vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.gaming.id}"
  cidr_block = "${var.cidr_block_subnet_public}"

  tags {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = "${aws_vpc.gaming.id}"
  cidr_block = "${var.cidr_block_subnet_private}"

  tags {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "pub_gw" {
  vpc_id     = "${aws_vpc.gaming.id}"
  depends_on = ["aws_vpc.gaming"]

  tags {
    Name = "gaming_gw"
  }
}

resource "aws_route_table" "pub_rt" {
  vpc_id = "${aws_vpc.gaming.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.pub_gw.id}"
  }

  tags {
    Name = "gaming_rt"
  }
}

resource "aws_route_table_association" "pub_rt_assoc" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.pub_rt.id}"
}

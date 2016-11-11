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
  vpc_id = "${aws_vpc.gaming.id}"
  depends_on = ["aws_vpc.gaming"]

  tags {
    Name = "gaming_gw"
  }
}

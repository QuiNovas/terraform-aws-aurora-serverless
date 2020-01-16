resource "aws_vpc" "vpc" {
  cidr_block = local.cidr_block
  tags = {
    Name = "${var.name}-vpc"
  }

}

data "aws_availability_zones" "available" {

}


resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  count             = local.subnets_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = local.private_subnets[count.index]

  tags = {
    Name = "${var.name}-private-subnet-${count.index}"
  }
}


resource "aws_subnet" "public" {

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.public_subnets[0]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {

    Name = "${var.name}-public-subnet"

  }

}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-public-route-table"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-public-igw"
  }
}

resource "aws_route" "public_internet_gateway" {

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {

  vpc = true

  tags = {
    Name = "${var.name}-aws-nat"
  }
}

resource "aws_nat_gateway" "ngw" {


  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id


  tags = {
    Name = "${var.name}-public-nat-gw"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "private_nat_gateway" {
  count                  = local.subnets_count
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.ngw.*.id, count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table" "private" {
  count = local.subnets_count

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-private-rt-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count = local.subnets_count

  subnet_id = element(aws_subnet.private.*.id, count.index)

  route_table_id = element(
    aws_route_table.private.*.id,
    count.index
  )
}

resource "aws_security_group" "base_sg" {

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }

  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    self      = true
  }

  name   = var.name
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-var.name"
  }
}




provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "vpc" {
  cidr_block = local.cidr_block
  tags = {
    Name = "${var.name}-vpc"
  }

}

resource "random_shuffle" "az" {
  input        = var.availability_zones
  result_count = local.subnets_count
}


resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  count             = local.subnets_count
  availability_zone = element(random_shuffle.az.result, count.index)
  cidr_block        = local.private_subnets[count.index]

  tags = {
    Name = "${var.name}-private-subnet-${count.index}"
  }
}


resource "aws_subnet" "public" {
  count = 1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.public_subnets[0]
  availability_zone = element(random_shuffle.az.result, count.index)

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
  subnet_id      = aws_subnet.public.0.id
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
  subnet_id     = aws_subnet.public.0.id


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
    Name = "${var.name}-default-sg"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.name}-main"
  subnet_ids = [aws_subnet.private.0.id , aws_subnet.private.1.id, aws_subnet.private.2.id ]
}
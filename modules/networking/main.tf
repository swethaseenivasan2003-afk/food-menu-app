resource "aws_vpc" "vpc" { 
  cidr_block     = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_subnet" "public" {
  count =      length(var.azs)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "${var.public_subnet_cidr[count.index]}"
  availability_zone = "${var.azs[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
    type = "Public"
  }
}

resource "aws_subnet" "private" {
  count =   length(var.azs)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "${var.private_subnet_cidr[count.index]}"
  availability_zone = "${var.azs[count.index]}"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
    type = "Private"
  }
}

resource "aws_eip" "eip" {
  count  = length(var.azs)
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  }
}


resource "aws_nat_gateway" "nat" {
  count = length(var.azs)  
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.project_name}-gw NAT-${count.index + 1}"
  }
  depends_on = [aws_internet_gateway.igw]
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count =  length(var.public_subnet_cidr) 
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = length(var.azs)   
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags ={
    Name = "${var.project_name}-Private-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private" {
  count =   length(var.private_subnet_cidr) 
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
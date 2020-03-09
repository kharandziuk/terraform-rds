resource "aws_subnet" "subnet" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidrs[count.index]

  tags = {
    Name = "main_subnet_${count.index}"
  }
}

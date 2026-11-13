# One NAT. The second AZ exists so the control plane can place an interface, not for node HA.
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.cluster_name}-nat"
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[var.node_az].id

  tags = {
    Name = var.cluster_name
  }
}

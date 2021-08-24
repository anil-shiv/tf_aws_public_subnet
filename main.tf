#Subnet
resource "aws_subnet" "public" {
  vpc_id = var.vpc_id
  cidr_block = element(var.cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  count = length(var.cidrs)
  map_public_ip_on_launch = var.map_public_ip_on_launch

  lifecycle {
      create_before_destroy = true
  }

  tags = {
      BusinessUnit = var.business_unit
      Name = "${var.name}.${element(var.azs, count.index)}"
      App = var.app_tag
      ManagedBy = var.managed_by
      Environment = var.env
      Role = "Public Subnet"
      Provisioner = "Terraform"
      DataClassification = var.data_classification
      Tier = var.tier
    }
}

#Routes
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  count = length(var.cidrs)

  tags = {
      BusinessUnit = var.business_unit
      Name = "${var.name}.${element(var.azs, count.index)}"
      App = var.app_tag
      ManagedBy = var.managed_by
      Environment = var.env
      Role = "Public Route Table"
      Provisioner = "Terraform"
    }
}

resource "aws_route_table_association" "public" {
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
  count = length(var.cidrs)

  lifecycle {
      create_before_destroy = true
  }
}

resource "aws_route" "igw" {
  route_table_id = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = var.igw_id
  count = length(var.cidrs)

  depends_on = [
      aws_route_table.public
  ]

  lifecycle {
      create_before_destroy = true
  }
}
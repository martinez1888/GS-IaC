#VPC
output "vpc_id" {
  value = aws_vpc.vpcgs.id

}

#SUBNET
output "sn_vpcgs_1a_id" {
  value = aws_subnet.sn_vpcgs_1a.id

}

output "sn_vpcgs_1c_id" {
  value = aws_subnet.sn_vpcgs_1c.id

}

output "sn_vpcgs_2a_id" {
  value = aws_subnet.sn_vpcgs_2a.id

}

output "sn_vpcgs_2c_id" {
  value = aws_subnet.sn_vpcgs_2c.id

}

output "sn_vpcgs_3a_id" {
  value = aws_subnet.sn_vpcgs_3a.id

}

output "sn_vpcgs_3c_id" {
  value = aws_subnet.sn_vpcgs_3c.id

}

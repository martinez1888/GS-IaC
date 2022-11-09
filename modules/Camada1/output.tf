#SECURITY GROUPS
output "sg_pub_id" {
  value = aws_security_group.sg_pub.id
}

output "sg_priv1_id" {
  value = aws_security_group.sg_priv1.id
}

output "sg_priv2_id" {
  value = aws_security_group.sg_priv2.id
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable."
  value       = concat(aws_instance.tcb_build-ec2.*.public_ip, [""])[0]
}
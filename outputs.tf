output "web1_public_ip" {
  value       = module.ec2_instance["web1"].public_ip
  description = "IP address of web1"
}

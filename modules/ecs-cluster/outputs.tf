/**
 * Outputs.
 */

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.ecs_cluster.id}"
}

output "ecs_cluster_instance_fqdns" {
  value = "${aws_route53_record.internal_dns_record.*.fqdn}"
}

output "ecs_cluster_instance_private_ips" {
  value = "${aws_instance.ecs_instance.*.private_ip}"
}

output "ecs_cluster_instance_private_dns" {
  value = "${aws_instance.ecs_instance.*.network_interface.PrivateDnsName}"
}

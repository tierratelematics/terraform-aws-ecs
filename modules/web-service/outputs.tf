/**
 * Outputs.
 */
output "route53_name" {
  value = "${aws_route53_record.service-alias.name}"
}

output "alb_dns_name" {
  value = "${module.alb.alb_dns_name}"
}

output "alb_zone_id" {
  value = "${module.alb.alb_zone_id}"
} 

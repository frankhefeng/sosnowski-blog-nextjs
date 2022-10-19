# resource "aws_acm_certificate" "blog_cert" {
#   provider = aws.us-east-1

#   domain_name       = "${var.website_domain}.${var.hosted_zone_domain}"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "acm_domain_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.blog_cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.primary.zone_id
# }

# resource "aws_acm_certificate_validation" "blog_validation" {
#   provider = aws.us-east-1
#   certificate_arn         = aws_acm_certificate.blog_cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.acm_domain_validation : record.fqdn]
# }

# data "aws_route53_zone" "primary" {
#   name = var.hosted_zone_domain
# }
# resource "aws_route53_record" "blog" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = var.website_domain
#   type    = "CNAME"
#   ttl     = 300

#   records        = [aws_cloudfront_distribution.blog.domain_name]
# }
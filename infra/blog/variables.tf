variable "hosted_zone_domain" {
  description = "Domain name of the Route 53 hosted zone this website domain should be added to"
  type = string
}

variable "website_domain" {
  description = "Main website domain, e.g. cloudmaniac.net"
  type = string
}
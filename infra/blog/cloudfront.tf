resource "aws_cloudfront_distribution" "blog" {
  comment = "A CloudFront distribution to S3 static blog files"
  enabled = true

  web_acl_id = ""
  is_ipv6_enabled = true
  default_root_object = "index.html"

  # aliases = ["${var.website_domain}.${var.hosted_zone_domain}"]
    origin {
    domain_name = aws_s3_bucket.blog_bucket.bucket_regional_domain_name
    origin_id   = "S3-blog-bucket"
    origin_access_control_id = aws_cloudfront_origin_access_control.blog.id
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true
    default_ttl     = 30 * 24 * 60 * 60

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    max_ttl                = 30 * 24 * 60 * 60 
    min_ttl                = 0
    target_origin_id       = "S3-blog-bucket"
    viewer_protocol_policy = "redirect-to-https"
  }
}

resource "aws_cloudfront_origin_access_control" "blog" {
  name                              = "blog"
  description                       = "blog CloudFront OAC Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
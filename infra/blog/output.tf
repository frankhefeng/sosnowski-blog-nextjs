output "blog_s3_bucket_name" {
  value       = aws_s3_bucket.blog_bucket.bucket
  description = "S3 Bucket for blog"
}
output "blog_cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.blog.id
  description = "Cloudfront distribution ID"
}
output "blog_cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.blog.domain_name
  description = "Cloudfront distribution domain name"
}

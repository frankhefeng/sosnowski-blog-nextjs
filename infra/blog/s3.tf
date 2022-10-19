
resource "aws_s3_bucket" "blog_bucket" {
  bucket = "sosnowski-blog-nextjs-965161619314-${var.branch_name}"

  tags = {
    Name = "sosnowski-blog-nextjs s3 origin ${var.branch_name}"
  }
}


resource "aws_s3_bucket_acl" "blog_bucket_acl" {
  bucket = aws_s3_bucket.blog_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "blog_bucket_public_access_block" {
  bucket = aws_s3_bucket.blog_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "blog_bucket_sse" {
  bucket = aws_s3_bucket.blog_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}



data "aws_iam_policy_document" "blog_bucket_oai_read_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.blog_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.blog.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "blog_bucket_policy" {
  bucket = aws_s3_bucket.blog_bucket.id
  policy = data.aws_iam_policy_document.blog_bucket_oai_read_policy.json
}
# This module creates an S3 bucket in AWS to store the React application.

module "bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "4.1.1"
  bucket        = "${var.project}-${var.env}"
  force_destroy = var.force_destroy
}

/**
 * Module: cloudfront
 * 
 * This module configures an AWS CloudFront distribution for the project.
 * It creates a CloudFront distribution with the specified settings, including origin access control,
 * default cache behavior, and custom error responses.
 * 
 * Inputs:
 * - source: The source of the CloudFront module. In this case, it is "terraform-aws-modules/cloudfront/aws".
 * - comment: The comment to be added to the CloudFront distribution. It is a combination of the project and environment variables.
 * - enabled: Whether the CloudFront distribution is enabled or not.
 * - http_version: The HTTP version to use for the CloudFront distribution.
 * - is_ipv6_enabled: Whether IPv6 is enabled for the CloudFront distribution.
 * - price_class: The price class for the CloudFront distribution.
 * - wait_for_deployment: Whether to wait for the CloudFront distribution to be deployed or not.
 * - create_origin_access_control: Whether to create origin access control for the CloudFront distribution or not.
 * - origin_access_control: The origin access control settings for the CloudFront distribution.
 * - origin: The origin settings for the CloudFront distribution.
 * - default_cache_behavior: The default cache behavior settings for the CloudFront distribution.
 * - custom_error_response: The custom error response settings for the CloudFront distribution.
 */
module "cloudfront" {
  source              = "terraform-aws-modules/cloudfront/aws"
  comment             = "${var.project}-${var.env}"
  enabled             = true
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  wait_for_deployment = false

  # This block of code enables origin access control for the specified project and environment.
  # It creates an origin access control configuration for an S3 origin, with the specified signing behavior and protocol.
  create_origin_access_control = true
  origin_access_control = {
    "${var.project}-${var.env}" = {
      description      = "${var.project}-${var.env}"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  # The `origin` block specifies the origin configuration for the CloudFront distribution.
  # It defines the S3 bucket as the origin and sets the domain name and origin access control.
  # The `domain_name` is set to the regional domain name of the S3 bucket obtained from the `module.bucket` output.
  # The `origin_access_control` is set to a combination of the `project` and `env` variables.
  # This ensures that the CloudFront distribution can access the S3 bucket with the specified access control.
  origin = {
    bucket = {
      domain_name           = module.bucket.s3_bucket_bucket_regional_domain_name
      origin_access_control = "${var.project}-${var.env}"
    }
  }

  default_cache_behavior = {
    cache_policy_name            = "Managed-CachingOptimized"
    origin_request_policy_name   = "Managed-UserAgentRefererHeaders"
    response_headers_policy_name = "Managed-SimpleCORS"
    use_forwarded_values         = false
    viewer_protocol_policy       = "redirect-to-https"
    target_origin_id             = "bucket"
    allowed_methods              = ["GET", "HEAD", "OPTIONS"]
    cached_methods               = ["GET", "HEAD"]
  }

  custom_error_response = [{
    error_code         = 404
    response_code      = 404
    response_page_path = "/index.html"
    }, {
    error_code         = 403
    response_code      = 403
    response_page_path = "/index.html"
  }]
}

# It allows the CloudFront service to access objects in the bucket using the "s3:GetObject" action.
# The policy is applied to the bucket specified by the "module.bucket.s3_bucket_arn" variable.
# The policy is only effective if the request originates from the CloudFront distribution specified by the "module.cloudfront.cloudfront_distribution_arn" variable.

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.bucket.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}

# This resource block defines an AWS S3 bucket policy. It associates the policy with the S3 bucket
# identified by the `module.bucket.s3_bucket_id` attribute. The policy is specified using the
# `data.aws_iam_policy_document.bucket_policy.json` data source.
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

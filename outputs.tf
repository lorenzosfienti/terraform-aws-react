/**
 * Output: url
 * Description: The URL of the CloudFront distribution.
 * Type: string
 */
output "url" {
  value = module.cloudfront.cloudfront_distribution_domain_name
}
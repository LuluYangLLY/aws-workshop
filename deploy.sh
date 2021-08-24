set -eu

ROOT_DOMAIN_NAME=tsen
STACK_NAME=mkr-bobo
DOMAIN_NAME=bobo-little-star-cf.aws.$ROOT_DOMAIN_NAME.me
BUCKET_NAME=bobos-bucket
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[?contains(Name, '$ROOT_DOMAIN_NAME')].Id" --output text | cut -c 13-)

aws cloudformation deploy \
  --stack-name $STACK_NAME \
  --no-fail-on-empty-changeset \
  --template-file "cloudformation.yml" \
  --parameter-overrides \
  "BucketName=$BUCKET_NAME" \
  "DomainName=$DOMAIN_NAME" \
  "HostedZoneId=$HOSTED_ZONE_ID"

docker compose run --rm install
docker compose run --rm build

aws s3 cp build s3://$BUCKET_NAME --recursive
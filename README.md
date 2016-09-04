# acmesmith-docker

Dockerized HTTPS server using Let's Encrypt certificate continuously managed by [acmesmith](https://github.com/sorah/acmesmith).

## Prerequisite

- Docker Compose
- AWS S3 for Storing the account and certificate
- AWS Route53 for ACME challenge

## How to use

### Set up acmesmith

Create an IAM user with following role for S3 and Route53 operation.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
      "Resource": ["arn:aws:s3:::YOUR_BUCKET", "arn:aws:s3:::YOUR_BUCKET/cert"]
    },
    {
      "Effect": "Allow",
      "Action": ["route53:ListHostedZones", "route53:GetChange"],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "route53:ChangeResourceRecordSets",
      "Resource": ["arn:aws:route53:::hostedzone/YOUR_HOSTED_ZONE"]
    }
  ]
}
```

Create `acmesmith/acmesmith.yml` as the example in same folder.

Now request a certificate.

```sh
docker-compose build acmesmith
docker-compose run --rm acmesmith register mailto:you@example.com
docker-compose run --rm acmesmith authorize example.com
docker-compose run --rm acmesmith request example.com
docker-compose run --rm acmesmith list
```

### Set up web server

Change `reverse-proxy/nginx.conf` to fit your environment.
Other web servers such as Apache httpd may work as well.

Now start the web server.

```sh
COMMON_NAME=example.com ./renew.sh
```

### Continuously renew the certificate

Run the script.
If the certificate is being expired soon, the web server is restarted with an new certificate.
Otherwise, the web server is not restarted.

```sh
COMMON_NAME=example.com ./renew.sh
```

The script is designed to be idempotent.
Run the script periodically by the scheduler such as cron.

## Contribution

This is an open source software licensed under Apache-2.0.
Feel free to open issues and pull requests.


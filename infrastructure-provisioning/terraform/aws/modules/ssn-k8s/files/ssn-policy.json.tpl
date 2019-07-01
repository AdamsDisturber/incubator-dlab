{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListAllMyBuckets",
      "Resource": "arn:aws:s3:::*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:PutBucketPolicy",
        "s3:PutEncryptionConfiguration"
      ],
      "Resource": [
        "${bucket_arn}"
	  ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:HeadObject",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "${bucket_arn}/*"
      ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "autoscaling:DescribeAutoScalingInstances",
            "ec2:DescribeInstances",
            "elasticloadbalancing:DescribeTargetHealth"
        ],
        "Resource": "*"
    }
  ]
}
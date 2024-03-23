provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"    
}

resource "aws_elastic_beanstalk_application" "whizapp"{
    name        = "test"
    description = "Sample Test Application"
}

resource "aws_iam_instance_profile" "subject_profile" {
  name = "test_role_new"
  role = aws_iam_role.role.name
}
resource "aws_iam_role" "role" {
  name = "test_role_new"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier", 
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
  ])

  role = "${aws_iam_role.role.name}"
  policy_arn = each.value
}
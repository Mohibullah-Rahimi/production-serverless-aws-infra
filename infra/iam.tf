# IAM policy document that allows Lambda to assume this role
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Inline policy for Lambda (for now just an example: describe RDS)
data "aws_iam_policy_document" "lambda_inline" {
  statement {
    sid = "AllowDescribeRDS"

    effect = "Allow"

    actions = [
      "rds:DescribeDBInstances",
    ]

    resources = ["*"]
  }
}

# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_exec" {
  name               = "${var.project_name}-lambda-exec-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Attach the inline policy to the role
resource "aws_iam_role_policy" "lambda_inline" {
  name   = "${var.project_name}-lambda-inline-policy"
  role   = aws_iam_role.lambda_exec.id
  policy = data.aws_iam_policy_document.lambda_inline.json
}

# Attach the AWS managed basic Lambda logging policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach the AWS managed VPC access policy so Lambda can create ENIs in your VPC
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

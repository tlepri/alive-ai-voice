resource "aws_iam_role" "mia_lambda" {
  name_prefix = "alive-ai-voice-lambda-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "mia_logs" {
  role       = aws_iam_role.mia_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "mia_s3_read" {
  name = "mia-friends-read"
  role = aws_iam_role.mia_lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.mia_friends.arn}/friends.json"
      }
    ]
  })
}

resource "aws_iam_role_policy" "mia_secret_read" {
  name = "mia-api-key-read"
  role = aws_iam_role.mia_lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = "arn:aws:secretsmanager:us-east-1:730345078180:secret:alive-ai-voice/mia-api-key-??????"
    }]
  })
}
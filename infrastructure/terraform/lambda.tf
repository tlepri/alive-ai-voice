resource "aws_lambda_function" "mia" {
  function_name = "alive-ai-voice-mia"
  role          = aws_iam_role.mia_lambda.arn

  filename         = "${path.module}/../../build/mia-lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/../../build/mia-lambda.zip")

  runtime       = "python3.12"
  architectures = ["arm64"]
  handler       = "backend.main.handler"

  memory_size                    = 256
  timeout                        = 15
  reserved_concurrent_executions = 5

  environment {
    variables = {
      MIA_FRIENDS_BUCKET = aws_s3_bucket.mia_friends.id
      MIA_FRIENDS_KEY    = "friends.json"
      MIA_API_SECRET_ID  = "alive-ai-voice/mia-api-key"
    }
  }
}
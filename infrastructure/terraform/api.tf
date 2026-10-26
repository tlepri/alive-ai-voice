resource "aws_apigatewayv2_api" "mia" {
  name          = "alive-ai-voice-mia-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "mia" {
  api_id                 = aws_apigatewayv2_api.mia.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.mia.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "mia_friend" {
  api_id    = aws_apigatewayv2_api.mia.id
  route_key = "GET /friend"
  target    = "integrations/${aws_apigatewayv2_integration.mia.id}"
}

resource "aws_apigatewayv2_stage" "mia" {
  api_id      = aws_apigatewayv2_api.mia.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "mia_api" {
  statement_id  = "AllowMiaAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mia.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.mia.execution_arn}/*/*"
}

output "mia_api_url" {
  value = aws_apigatewayv2_api.mia.api_endpoint
}
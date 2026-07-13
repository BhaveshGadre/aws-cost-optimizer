resource "aws_sns_topic" "cost-alerts" {
    name = "cost-alerts"
      
}

resource "aws_sns_topic_subscription" "email" {
    topic_arn = aws_sns_topic.cost-alerts.arn
    protocol  = "email"
    endpoint  = var.alert_email
}

resource "aws_budgets_budget" "monthly" {
    name              = "monthly-budget"
    budget_type       = "COST"
    limit_amount      = tostring(var.monthly_budget_limit)
    limit_unit        = "USD"
    time_unit         = "MONTHLY"
       
    notification {
      comparison_operator = "GREATER_THAN"
      threshold           = 80
      threshold_type      = "PERCENTAGE"
      notification_type   = "ACTUAL"
  
      subscriber_sns_topic_arns = [ aws_sns_topic.cost-alerts.arn ]
      
    }
}

resource "aws_iam_role" "lambda_role" {
    name = "cost-optimizer-lambda-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
  
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

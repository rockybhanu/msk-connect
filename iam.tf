resource "aws_iam_role" "msk_connect_role" {
  name = "MSKConnectExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kafkaconnect.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "msk_connect_policy" {
  name        = "MSKConnectPolicy"
  description = "Policy for MSK Connect to access MSK and Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeCluster",
          "kafka-cluster:DescribeClusterV2",
          "kafka-cluster:GetBootstrapBrokers",
          "kafka-cluster:AlterCluster",
          "kafka-cluster:CreateCluster",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:CreateTopic",
          "kafka-cluster:DeleteTopic",
          "kafka-cluster:WriteData",
          "kafka-cluster:ReadData",
          "kafka-cluster:AlterTopic",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:AlterGroup",
          "kafka-cluster:ListTopics",
          "kafka-cluster:ListClusters",
          "kafka-cluster:ListGroups",
          "kafka-cluster:DescribeNode",
          "kafka-cluster:AlterCluster",
          "kafka-cluster:DescribeConfiguration",
          "kafka-cluster:DescribeConfigurationRevision"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_msk_connect_policy" {
  role       = aws_iam_role.msk_connect_role.name
  policy_arn = aws_iam_policy.msk_connect_policy.arn
}

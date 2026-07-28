resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.project_name}-repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.project_name}-repository"
  }
}


resource "aws_ecr_lifecycle_policy" "app-repo-policy" {
  repository = aws_ecr_repository.app_repo.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images older than 5 days",
      "selection": {
        "tagStatus": "any",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 5
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
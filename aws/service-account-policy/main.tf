resource "aws_iam_policy" "this" {
  name   = var.name
  policy = data.aws_iam_policy_document.this.json
  tags   = var.tags
}

data "aws_iam_policy_document" "this" {
  source_policy_documents = var.policy_documents
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.role_names)

  policy_arn = aws_iam_policy.this.arn
  role       = each.value
}

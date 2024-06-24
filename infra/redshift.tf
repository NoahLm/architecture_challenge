# Create Redshift Cluster
resource "aws_redshift_cluster" "my_redshift_cluster" {
  cluster_identifier = "noe-redshift-cluster-by-challenge"
  database_name      = "dev"
  master_username    = var.redshift_master_username
  master_password    = var.redshift_master_password
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  iam_roles          = [aws_iam_role.redshift_role.arn]
  port               = 5439
  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.subnet_group.name
}
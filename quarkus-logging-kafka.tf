# Create repository
resource "github_repository" "quarkus_logging_kafka" {
  name                   = "quarkus-logging-kafka"
  description            = "Quarkus logging extension sending log statements to Kafka."
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["kafka", "logging", "quarkus", "quarkus-extension", "observability", "otel"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_logging_kafka" {
  name                      = "quarkus-logging-kafka"
  description               = "Quarkiverse team for the logging-kafka extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_logging_kafka" {
  team_id    = github_team.quarkus_logging_kafka.id
  repository = github_repository.quarkus_logging_kafka.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_logging_kafka" {
  for_each = { for tm in ["cescoffier", "ozangunalp", "alesj"] : tm => tm }
  team_id  = github_team.quarkus_logging_kafka.id
  username = each.value
  role     = "maintainer"
}

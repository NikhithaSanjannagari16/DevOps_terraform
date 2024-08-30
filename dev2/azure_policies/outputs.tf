output "auditRoleAssignmentType_user_policy_id" {
  value       = "${azurerm_policy_definition.auditRoleAssignmentType_user.id}"
  description = "The policy definition id for auditRoleAssignmentType_user"
}
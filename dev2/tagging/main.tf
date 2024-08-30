resource "azurerm_policy_definition" "addTagToRG" {
  count        = "${length(var.tag_list)}"
  name         = "addTagToRG-${var.tag_list[count.index]}"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "${var.tag_list[count.index]} Tag to resource group"
  description  = "This policy will make it mandatory for the user to add specified tags whenever creating a Resource Group."
  metadata = <<METADATA
    {
    "category": "General",
    "version" : "1.0.0"
    }
  METADATA
  policy_rule = <<POLICY_RULE
  {
      "if": {
        "allof": [
          {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "exists": "false"
          },
          {
            "field": "type",
            "equals": "Microsoft.Resources/subscriptions/resourceGroups"
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }
  POLICY_RULE
parameters = <<PARAMETERS
    {
        "tagName": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.tag_list[count.index]}",
            "description": "Name of the tag, such as ${var.tag_list[count.index]}"
          },
          "defaultValue": "${var.tag_list[count.index]}"
        }
}
PARAMETERS
}

resource "azurerm_subscription_policy_assignment" "example" {
  count        	       = "${length(var.tag_list)}"
  name                 = "mandatory-tags-forRG-${var.tag_list[count.index]}"
  subscription_id      = "/subscriptions/${module.globals.subscription_id}"
  policy_definition_id = element(azurerm_policy_definition.addTagToRG.*.id,count.index)
  description          = "Policy Assignment created for Mandatory Tags"
  display_name         = "Mandatory Tags Assignment-${var.tag_list[count.index]}"

  metadata = <<METADATA
    {
    "category": "General"
    }
METADATA

  parameters = jsonencode({
         "tagName": {
           "value":  var.tag_list[count.index],
          }
      }
  )
}
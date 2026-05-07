#!/usr/bin/env bash
# Auto-approve Bash permission requests for the mr CLI.
# On first approval, saves the rule to user settings so the hook never fires again.

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

if [[ "$command" =~ ^mr[[:space:]] ]] || [[ "$command" =~ /mr[[:space:]] ]]; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PermissionRequest",
      decision: {
        behavior: "allow",
        updatedPermissions: [{
          type: "addRules",
          rules: [{"toolName": "Bash", "ruleContent": "mr *"}, {"toolName": "Bash", "ruleContent": "*/mr *"}],
          behavior: "allow",
          destination: "userSettings"
        }]
      }
    }
  }'
  exit 0
fi

exit 0

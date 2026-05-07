#!/usr/bin/env bash
# Auto-approve permission requests for the mr CLI and /tmp/ file access.
# On first approval, saves rules to user settings so the hook never fires again.

input=$(cat)
tool=$(echo "$input" | jq -r '.tool_name // empty')
command=$(echo "$input" | jq -r '.tool_input.command // empty')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Approve mr CLI commands
if [[ "$command" =~ ^mr[[:space:]] ]] || [[ "$command" =~ /mr[[:space:]] ]]; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PermissionRequest",
      decision: {
        behavior: "allow",
        updatedPermissions: [{
          type: "addRules",
          rules: [
            {"toolName": "Bash", "ruleContent": "mr *"},
            {"toolName": "Bash", "ruleContent": "*/mr *"}
          ],
          behavior: "allow",
          destination: "userSettings"
        }]
      }
    }
  }'
  exit 0
fi

# Approve Read and Write for /tmp/
if [[ "$tool" == "Read" || "$tool" == "Write" ]] && [[ "$file_path" =~ ^/tmp/ ]]; then
  jq -n --arg tool "$tool" '{
    hookSpecificOutput: {
      hookEventName: "PermissionRequest",
      decision: {
        behavior: "allow",
        updatedPermissions: [{
          type: "addRules",
          rules: [
            {"toolName": "Read", "ruleContent": "/tmp/*"},
            {"toolName": "Write", "ruleContent": "/tmp/*"}
          ],
          behavior: "allow",
          destination: "userSettings"
        }]
      }
    }
  }'
  exit 0
fi

exit 0

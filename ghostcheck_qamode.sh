#!/bin/bash
# 👻 GhostCheck QA Mode – Smarter Self-Test for GhostOps Scripts

echo "🔍 Running GhostOps QA Self-Test..."
echo "--------------------------------------------"

HELPERS="./ghostops_helpers.sh"
[[ ! -f $HELPERS ]] && echo "❌ Missing $HELPERS — cannot run tests!" && exit 1

passed=0
failed=0

for script in *.sh; do
  [[ "$script" == "ghostops_helpers.sh" ]] && continue
  [[ "$script" == "ghostcheck_qamode.sh" ]] && continue

  echo -e "\n📂 Testing: $script"

  # Check if script is executable
  if [[ ! -x "$script" ]]; then
    echo "⚠️  Not executable. Run: chmod +x $script"
    ((failed++))
    continue
  fi

  # Check for require_tools usage
  if grep -q "require_tools" "$script"; then

    # Check for correct source line if require_tools is used
    if ! grep -Eq '^\s*source\s+\.\/ghostops_helpers\.sh' "$script"; then
      echo "❌ Missing: source ./ghostops_helpers.sh"
      ((failed++))
      continue
    fi

    # Extract tools from require_tools line
    req_line=$(grep "require_tools" "$script" | head -1)
    tools=$(echo "$req_line" | cut -d' ' -f2-)
    missing=()

    for tool in $tools; do
      if ! command -v "$tool" &>/dev/null; then
        missing+=("$tool")
      fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
      echo -e "❌ Missing required tools: \e[91m${missing[*]}\e[0m"
      echo "➡️  Install with: sudo apt install ${missing[*]}"
      ((failed++))
    else
      echo "✅ All required tools found"
      ((passed++))
    fi

  else
    echo "✅ No dependencies required"
    ((passed++))
  fi
done

echo -e "\n✅ Passed: $passed    ❌ Failed: $failed"
echo "--------------------------------------------"

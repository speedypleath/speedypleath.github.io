#!/bin/bash
# Check GitHub Pages deployment status

REPO="speedypleath/speedypleath.github.io"

echo "🔍 Checking deployment status for $REPO..."
echo ""

# Get latest deployment
gh api "repos/$REPO/pages/builds/latest" --jq '{
  status: .status,
  commit: .commit[:7],
  duration: .duration,
  updated_at: .updated_at
}' 2>/dev/null

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Deployment info retrieved successfully"
else
    echo "❌ Failed to get deployment status"
    exit 1
fi

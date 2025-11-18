#!/bin/bash

echo "========================================"
echo "GitHub Repository Access Checker"
echo "========================================"
echo ""

# Check if GitHub CLI is authenticated
echo "1. Checking GitHub CLI authentication..."
if gh auth status 2>&1 | grep -q "Logged in"; then
    echo "✓ GitHub CLI is authenticated"
    gh auth status
else
    echo "✗ GitHub CLI is not authenticated"
fi

echo ""
echo "2. Checking GITHUB_TOKEN environment variable..."
if [ -n "$GITHUB_TOKEN" ]; then
    echo "✓ GITHUB_TOKEN is set (length: ${#GITHUB_TOKEN} characters)"
else
    echo "✗ GITHUB_TOKEN is not set"
fi

echo ""
echo "3. Checking access to test-schemas repository..."
if gh repo view jburgess/test-schemas &> /dev/null; then
    echo "✓ You have access to jburgess/test-schemas"
    echo ""
    gh repo view jburgess/test-schemas --json name,visibility,viewerPermission
else
    echo "✗ Cannot access jburgess/test-schemas"
    echo ""
    echo "Possible reasons:"
    echo "  - Repository doesn't exist"
    echo "  - Repository is private and you don't have access"
    echo "  - Token doesn't have required permissions"
fi

echo ""
echo "4. Testing Git clone with token..."
if [ -n "$GITHUB_TOKEN" ]; then
    TEST_URL="https://x-access-token:${GITHUB_TOKEN}@github.com/jburgess/test-schemas.git"
    echo "Attempting to clone (will fail if no access)..."
    git ls-remote "$TEST_URL" &> /dev/null
    if [ $? -eq 0 ]; then
        echo "✓ Git clone with token would succeed"
    else
        echo "✗ Git clone with token fails - permission denied"
    fi
else
    echo "⚠️  Cannot test - GITHUB_TOKEN not available"
fi

echo ""
echo "========================================"
echo "Recommendations:"
echo "========================================"
echo ""
echo "If access check failed:"
echo "  1. Verify you own/have access to jburgess/test-schemas"
echo "  2. Make the repository public (easiest solution)"
echo "  3. Or: Configure Codespace with a PAT that has repo access"
echo ""
echo "To make repository public:"
echo "  → https://github.com/jburgess/test-schemas/settings"
echo "  → Scroll to 'Danger Zone'"
echo "  → Click 'Change visibility' → 'Make public'"
echo ""

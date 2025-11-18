#!/bin/bash

set -e

echo "================================================"
echo "Setting up test-apis development environment"
echo "================================================"

# Ensure gradlew has execute permissions
chmod +x gradlew

# Configure Git to use GitHub CLI for authentication
echo ""
echo "Configuring Git authentication..."
if command -v gh &> /dev/null && [ -n "$GITHUB_TOKEN" ]; then
    # Configure Git credential helper to use GitHub CLI
    git config --global credential.helper ""
    git config --global credential.helper "!gh auth git-credential"
    echo "✓ Git configured to use GitHub CLI authentication"
else
    echo "⚠️  GitHub CLI or GITHUB_TOKEN not available"
    echo "   Schemas from private repositories may fail to fetch"
fi

# Display Java version
echo ""
echo "Java version:"
java -version

# Check if Gradle is available
echo ""
if command -v gradle &> /dev/null; then
    echo "System Gradle version:"
    gradle --version
else
    echo "Using Gradle Wrapper (no system Gradle installed)"
fi

echo ""
echo "Project Gradle Wrapper version:"
./gradlew --version

# Fetch schemas automatically
echo ""
echo "Fetching schemas from test-schemas repository..."
./gradlew fetchSchemas || {
    echo ""
    echo "⚠️  Warning: Schema fetch failed. You may need to configure Git credentials."
    echo "   This is normal if the test-schemas repository is private."
    echo ""
    echo "   To configure authentication:"
    echo "   1. For HTTPS: git config --global credential.helper store"
    echo "   2. For SSH: Add your SSH key to GitHub"
    echo ""
    echo "   Then run: ./gradlew fetchSchemas"
    echo ""
    exit 0
}

# Display schema info
echo ""
./gradlew schemaInfo

echo ""
echo "================================================"
echo "✓ Development environment setup complete!"
echo "================================================"
echo ""
echo "Quick start commands:"
echo "  ./gradlew build          - Build the project"
echo "  ./gradlew schemaInfo     - Display schema mappings"
echo "  ./gradlew fetchSchemas   - Fetch schemas if needed"
echo "  ./gradlew refreshSchemas - Force refresh all schemas"
echo ""

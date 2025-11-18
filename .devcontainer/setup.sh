#!/bin/bash

set -e

echo "================================================"
echo "Setting up test-apis development environment"
echo "================================================"

# Display Java and Gradle versions
echo ""
echo "Java version:"
java -version

echo ""
echo "Gradle version:"
./gradlew --version

# Fetch schemas automatically
echo ""
echo "Fetching schemas from test-schemas repository..."
./gradlew fetchSchemas || {
    echo "⚠️  Warning: Schema fetch failed. You may need to configure Git credentials."
    echo "   Run './gradlew fetchSchemas' manually after configuring authentication."
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

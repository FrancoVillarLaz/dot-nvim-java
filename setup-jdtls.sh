#!/bin/bash
# Setup script para instalar y configurar JDTLS y herramientas Java en Neovim

set -e

echo "🚀 Installing JDTLS and Java tools for Neovim..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java is not installed${NC}"
    echo "Please install Java 21 first"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -1)
echo -e "${GREEN}✓ Java found: $JAVA_VERSION${NC}"
echo ""

# Check if Neovim is installed
if ! command -v nvim &> /dev/null; then
    echo -e "${RED}❌ Neovim is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Neovim found$(nvim --version | head -1)${NC}"
echo ""

# Install Mason packages
echo -e "${YELLOW}📦 Installing Mason packages...${NC}"
nvim --headless -u ~/.config/nvim/init.lua "+Lazy! sync" "+MasonInstall jdtls java-debug-adapter java-test stylua" "+qa" 2>&1 | grep -E "^|jdtls|java-debug|java-test|stylua" || true

echo ""
echo -e "${GREEN}✓ Mason packages installation completed${NC}"
echo ""

# Create Java workspace directory
JAVA_WORKSPACE="$HOME/.local/share/nvim/site/java/workspace-root"
mkdir -p "$JAVA_WORKSPACE"
echo -e "${GREEN}✓ Created Java workspace directory: $JAVA_WORKSPACE${NC}"
echo ""

# Verify JDTLS installation
JDTLS_PATH="$HOME/.local/share/nvim/mason/packages/jdtls"
if [ -d "$JDTLS_PATH" ]; then
    echo -e "${GREEN}✓ JDTLS installed at: $JDTLS_PATH${NC}"
    ls -lh "$JDTLS_PATH/plugins/" | grep "equinox.launcher" | head -1
else
    echo -e "${RED}❌ JDTLS installation not found${NC}"
    exit 1
fi
echo ""

# Summary
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "JDTLS and Java tools are now configured for Neovim!"
echo ""
echo -e "${YELLOW}Quick Start Commands:${NC}"
echo "  - <leader>jo      : Organize imports"
echo "  - <leader>jv      : Extract variable"
echo "  - <leader>jc      : Extract constant"
echo "  - <leader>jm      : Extract method"
echo "  - <leader>jtc     : Test class"
echo "  - <leader>jtm     : Test method"
echo "  - <leader>jr      : Run application (Spring Boot/Quarkus)"
echo "  - <leader>jB      : Build project"
echo "  - <leader>ji      : Install dependencies"
echo "  - <leader>jcf     : Open config file"
echo ""
echo -e "${YELLOW}For Maven projects:${NC}"
echo "  ./mvnw spring-boot:run     # Run Spring Boot app"
echo "  ./mvnw quarkus:dev         # Run Quarkus in dev mode"
echo ""
echo -e "${YELLOW}For Gradle projects:${NC}"
echo "  ./gradlew bootRun          # Run Spring Boot app"
echo "  ./gradlew quarkusDev       # Run Quarkus in dev mode"
echo ""
echo -e "${GREEN}Happy coding! 🎉${NC}"

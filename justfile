# Justfile for WMC-Projekt01
# Set shell for all recipes
set shell := ["zsh", "-c"]

# Variables
BINARY_NAME := "blackchat"
MAIN_FILE := "main.go"
BUILD_DIR := "build"

# Default recipe (shows available commands)
default:
    @echo "Available commands:"
    @echo "  just install  - Install Go (if needed) and project dependencies"
    @echo "  just build    - Build the project"
    @echo "  just run      - Run the project"
    @echo "  just clean    - Clean build artifacts"
    @echo "  just dev      - Run in development mode with auto-reload"
    @echo "  just test     - Run tests"
    @echo "  just fmt      - Format Go code"
    @echo "  just vet      - Run go vet"
    @echo "  just mod-tidy - Tidy up go.mod and go.sum"

# Install Go (if not installed) and project dependencies
install:
    #!/usr/bin/env zsh
    echo "🔧 Setting up development environment..."
    
    # Check if Go is installed
    if ! command -v go &> /dev/null; then
        echo "❌ Go is not installed. Installing Go..."
        
        # Check if Homebrew is available (macOS)
        if command -v brew &> /dev/null; then
            echo "📦 Installing Go via Homebrew..."
            brew install go
        else
            echo "❌ Homebrew not found. Please install Go manually from https://golang.org/dl/"
            echo "Or install Homebrew first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            exit 1
        fi
    else
        echo "✅ Go is already installed: $(go version)"
    fi
    
    # Verify Go installation
    if ! command -v go &> /dev/null; then
        echo "❌ Go installation failed"
        exit 1
    fi
    
    # Set up Go environment (for zsh)
    if [[ -f ~/.zshrc ]]; then
        if ! grep -q "export GOPATH" ~/.zshrc; then
            echo "🔧 Setting up Go environment variables..."
            echo "" >> ~/.zshrc
            echo "# Go environment" >> ~/.zshrc
            echo "export GOPATH=\$HOME/go" >> ~/.zshrc
            echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.zshrc
            echo "✅ Added Go environment variables to ~/.zshrc"
            echo "💡 Please run 'source ~/.zshrc' or restart your terminal"
        fi
    fi
    
    # Install project dependencies
    echo "📦 Installing project dependencies..."
    go mod download
    go mod verify
    
    # Install development tools
    echo "🛠️  Installing development tools..."
    go install github.com/air-verse/air@latest || echo "⚠️  Could not install air (live reload tool)"
    
    echo "✅ Installation complete!"

# Build the project
build:
    @echo "🔨 Building project..."
    @mkdir -p {{BUILD_DIR}}
    go build -o {{BUILD_DIR}}/{{BINARY_NAME}} {{MAIN_FILE}}
    @echo "✅ Build complete! Binary: {{BUILD_DIR}}/{{BINARY_NAME}}"

# Run the project
run: build
    @echo "🚀 Starting application..."
    @./{{BUILD_DIR}}/{{BINARY_NAME}}

# Clean build artifacts
clean:
    @echo "🧹 Cleaning build artifacts..."
    @rm -rf {{BUILD_DIR}}
    @go clean
    @echo "✅ Clean complete!"

# Run in development mode with auto-reload (requires air)
dev:
    #!/usr/bin/env zsh
    if command -v air &> /dev/null; then
        echo "🔥 Starting development server with auto-reload..."
        air
    else
        echo "⚠️  Air not found. Running without auto-reload..."
        echo "💡 Install air with: go install github.com/air-verse/air@latest"
        just run
    fi

# Run tests
test:
    @echo "🧪 Running tests..."
    go test -v ./...

# Format Go code
fmt:
    @echo "📝 Formatting Go code..."
    go fmt ./...
    @echo "✅ Code formatted!"

# Run go vet (static analysis)
vet:
    @echo "🔍 Running go vet..."
    go vet ./...
    @echo "✅ Vet complete!"

# Tidy up go.mod and go.sum
mod-tidy:
    @echo "🧹 Tidying up modules..."
    go mod tidy
    @echo "✅ Modules tidied!"

# Full check (fmt, vet, test, build)
check: fmt vet test build
    @echo "✅ All checks passed!"

# Install and set up everything from scratch
setup: install
    @echo "🎯 Running initial setup..."
    just mod-tidy
    just fmt
    just build
    @echo "🎉 Setup complete! Run 'just run' to start the application."
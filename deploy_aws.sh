#!/usr/bin/env bash
# ==============================================================================
# 🚀 Stocl Backend - Automated One-Click AWS Server Deployment Script
# Supports: Ubuntu 22.04 LTS / Ubuntu 24.04 LTS on AWS EC2
# ==============================================================================
set -e

echo "=========================================================="
echo "📦 Setting up Stocl Backend on AWS EC2 Server"
echo "=========================================================="

# 1. Update system packages
echo "--> Updating apt packages..."
sudo apt-get update -y && sudo apt-get upgrade -y

# 2. Install Docker & Docker Compose if not installed
if ! command -v docker &> /dev/null; then
    echo "--> Installing Docker and Docker Compose..."
    sudo apt-get install -y docker.io docker-compose git curl
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"
    echo "Docker installed successfully."
fi

# 3. Create .env from template if missing
if [ ! -f .env ]; then
    echo "--> Creating .env from .env.example..."
    cp .env.example .env
    echo "NOTE: Please verify your production DATABASE_URL and GROQ_API_KEY in .env"
fi

# 4. Build and run Docker containers
echo "--> Building and starting Stocl Backend container..."
docker-compose down || true
docker-compose up -d --build

# 5. Wait for healthcheck
echo "--> Waiting for backend service to become healthy..."
sleep 5
for i in {1..10}; do
    if curl -s http://localhost:8000/health | grep -q "healthy"; then
        echo "✅ Backend is healthy and running on port 8000!"
        break
    fi
    echo "Waiting for server startup ($i/10)..."
    sleep 3
done

# 6. Show status
echo "=========================================================="
echo "🎉 DEPLOYMENT COMPLETE!"
echo "Public Endpoints:"
echo "  - Frontend UI Dashboard : http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || echo 'YOUR_EC2_IP'):8000/"
echo "  - Interactive Swagger Docs: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || echo 'YOUR_EC2_IP'):8000/docs"
echo "  - Health Check API       : http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || echo 'YOUR_EC2_IP'):8000/health"
echo "=========================================================="

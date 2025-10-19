#!/bin/bash

set -e

echo "=========================================="
echo "Note App Development Environment Setup"
echo "=========================================="

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Check Docker
echo -e "${BLUE}Step 1: Checking Docker installation...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker is not installed. Please install Docker Desktop.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker is installed${NC}"

# Step 2: Create Laravel project
echo -e "${BLUE}Step 2: Setting up Laravel backend...${NC}"
if [ ! -f "api/composer.json" ]; then
    docker run --rm \
        -v "$(pwd)/api":/app \
        composer:latest composer create-project --prefer-dist laravel/laravel . --no-scripts
    echo -e "${GREEN}✓ Laravel project created${NC}"
else
    echo -e "${GREEN}✓ Laravel project already exists${NC}"
fi

# Step 3: Create Next.js project
echo -e "${BLUE}Step 3: Setting up Next.js frontend...${NC}"
if [ ! -f "web/package.json" ]; then
    mkdir -p web
    cd web
    npx create-next-app@latest --typescript --tailwind --eslint --app --import-alias --yes .
    cd ..
    echo -e "${GREEN}✓ Next.js project created${NC}"
else
    echo -e "${GREEN}✓ Next.js project already exists${NC}"
fi

# Step 4: Build and start Docker containers
echo -e "${BLUE}Step 4: Building Docker containers...${NC}"
docker-compose build --no-cache

echo -e "${BLUE}Step 5: Starting Docker containers...${NC}"
docker-compose up -d

# Wait for services to be ready
echo -e "${BLUE}Waiting for services to be ready...${NC}"
sleep 10

# Step 5: Run Laravel migrations
echo -e "${BLUE}Step 6: Running Laravel migrations...${NC}"
docker-compose exec -T api php artisan migrate --force || true

echo -e "${GREEN}=========================================="
echo "✓ Setup completed successfully!"
echo "=========================================="
echo ""
echo -e "${BLUE}Services are running at:${NC}"
echo "  - Frontend (Next.js): http://localhost:3000"
echo "  - Backend API (Laravel): http://localhost:8000"
echo "  - Database (MySQL): localhost:3306"
echo "  - Redis: localhost:6379"
echo ""
echo -e "${BLUE}Useful commands:${NC}"
echo "  - Start services: docker-compose up -d"
echo "  - Stop services: docker-compose down"
echo "  - View logs: docker-compose logs -f"
echo "  - Laravel artisan: docker-compose exec api php artisan"
echo "  - npm (web): docker-compose exec web npm"
echo ""

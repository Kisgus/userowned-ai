#!/bin/bash

# X API Credentials Setup Script
# Run this after regenerating tokens in X Developer Portal

echo "🔑 Setting up X API credentials for NEARWEEK UserOwned.AI"
echo "=================================================="

# Check if .env exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
fi

echo ""
echo "📋 Please paste your X API credentials from Developer Portal:"
echo ""

# API Key and Secret
read -p "🔑 API Key: " TWITTER_API_KEY
read -s -p "🔑 API Secret: " TWITTER_API_SECRET
echo ""

# Bearer Token
read -s -p "🎫 Bearer Token: " TWITTER_BEARER_TOKEN
echo ""

# Access Token and Secret (for media uploads)
read -p "🎟️  Access Token: " TWITTER_ACCESS_TOKEN
read -s -p "🎟️  Access Token Secret: " TWITTER_ACCESS_TOKEN_SECRET
echo ""

# Update .env file
echo "📝 Updating .env file..."

# Remove existing Twitter variables
grep -v "^TWITTER_" .env > .env.tmp && mv .env.tmp .env

# Add new credentials
cat >> .env << EOF

# X (Twitter) API Credentials
TWITTER_API_KEY=${TWITTER_API_KEY}
TWITTER_API_SECRET=${TWITTER_API_SECRET}
TWITTER_BEARER_TOKEN=${TWITTER_BEARER_TOKEN}
TWITTER_ACCESS_TOKEN=${TWITTER_ACCESS_TOKEN}
TWITTER_ACCESS_TOKEN_SECRET=${TWITTER_ACCESS_TOKEN_SECRET}

# X API Configuration
TWITTER_ENABLE_REAL_API=true
TWITTER_API_TIER=basic
TWITTER_MONTHLY_LIMIT=15000
TWITTER_DAILY_LIMIT=500
TWITTER_RATE_LIMIT_DELAY=2000

EOF

echo "✅ Credentials saved to .env file"

# Test the connection
echo ""
echo "🧪 Testing API connection..."
node scripts/test-twitter-api-connection.js

echo ""
echo "🎉 Setup complete!"
echo "Next steps:"
echo "1. Run: npm run api:status"
echo "2. Test: npm run twitter:real --critical-only"
echo "3. Monitor: npm run api:test"

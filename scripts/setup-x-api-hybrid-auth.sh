#!/bin/bash

# X API Hybrid Authentication Setup
# Supports both OAuth 1.0a and OAuth 2.0 for maximum flexibility

echo "🔑 Setting up X API Hybrid Authentication for NEARWEEK UserOwned.AI"
echo "=================================================================="

# Check if .env exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env 2>/dev/null || echo "# NEARWEEK UserOwned.AI Configuration" > .env
fi

echo ""
echo "📋 Please enter your X API credentials:"
echo "   (You should have both old API keys and new OAuth 2.0 credentials)"
echo ""

# OAuth 1.0a credentials (existing)
echo "OAuth 1.0a Credentials (existing):"
read -p "🔑 API Key: " TWITTER_API_KEY
read -s -p "🔑 API Secret: " TWITTER_API_SECRET
echo ""

read -p "🎟️  Access Token: " TWITTER_ACCESS_TOKEN
read -s -p "🎟️  Access Token Secret: " TWITTER_ACCESS_TOKEN_SECRET
echo ""

# Bearer Token (existing)
echo "App-only Authentication (existing):"
read -s -p "🎫 Bearer Token: " TWITTER_BEARER_TOKEN
echo ""

# OAuth 2.0 credentials (new)
echo "OAuth 2.0 Credentials (new from User Authentication Setup):"
read -p "🆔 Client ID: " TWITTER_CLIENT_ID
read -s -p "🔐 Client Secret: " TWITTER_CLIENT_SECRET
echo ""

# Remove existing Twitter configuration
echo ""
echo "📝 Updating .env file with hybrid authentication..."
grep -v "^TWITTER_" .env > .env.tmp && mv .env.tmp .env

# Add comprehensive configuration
cat >> .env << EOF

# X (Twitter) API - Hybrid Authentication Setup
# Generated: $(date)

# OAuth 1.0a (for posting, media upload, legacy endpoints)
TWITTER_API_KEY=${TWITTER_API_KEY}
TWITTER_API_SECRET=${TWITTER_API_SECRET}
TWITTER_ACCESS_TOKEN=${TWITTER_ACCESS_TOKEN}
TWITTER_ACCESS_TOKEN_SECRET=${TWITTER_ACCESS_TOKEN_SECRET}

# App-only Authentication (for read-only operations)
TWITTER_BEARER_TOKEN=${TWITTER_BEARER_TOKEN}

# OAuth 2.0 (for user authorization flows, future features)
TWITTER_CLIENT_ID=${TWITTER_CLIENT_ID}
TWITTER_CLIENT_SECRET=${TWITTER_CLIENT_SECRET}

# API Configuration
TWITTER_ENABLE_REAL_API=true
TWITTER_API_TIER=basic
TWITTER_MONTHLY_LIMIT=15000
TWITTER_DAILY_LIMIT=500
TWITTER_RATE_LIMIT_DELAY=2000

# Authentication Strategy
TWITTER_USE_OAUTH1_FOR_POSTING=true
TWITTER_USE_BEARER_FOR_READING=true
TWITTER_USE_OAUTH2_FOR_USER_AUTH=true

# Callback URLs
TWITTER_CALLBACK_URL=https://userowned.ai/auth/callback
TWITTER_CALLBACK_URL_LOCAL=https://localhost:3000/auth/callback

EOF

echo "✅ Hybrid authentication configuration saved!"

# Validate setup
echo ""
echo "🔍 Validating configuration..."
echo "=============================="

validate_length() {
    local name=$1
    local value=$2
    local min_length=$3
    
    if [ ${#value} -ge $min_length ]; then
        echo "✅ $name: ${#value} characters (valid)"
        return 0
    else
        echo "⚠️  $name: ${#value} characters (seems short)"
        return 1
    fi
}

validate_length "API Key" "$TWITTER_API_KEY" 20
validate_length "API Secret" "$TWITTER_API_SECRET" 40
validate_length "Bearer Token" "$TWITTER_BEARER_TOKEN" 100
validate_length "Access Token" "$TWITTER_ACCESS_TOKEN" 40
validate_length "Access Token Secret" "$TWITTER_ACCESS_TOKEN_SECRET" 40
validate_length "Client ID" "$TWITTER_CLIENT_ID" 15
validate_length "Client Secret" "$TWITTER_CLIENT_SECRET" 40

echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "You now have:"
echo "✅ OAuth 1.0a - For posting tweets, uploading media"
echo "✅ Bearer Token - For read-only monitoring"  
echo "✅ OAuth 2.0 - For user authorization flows"
echo ""
echo "Next steps:"
echo "1. Test connection: npm run api:test"
echo "2. Test posting: npm run test:post"
echo "3. Start monitoring: npm run twitter:critical"

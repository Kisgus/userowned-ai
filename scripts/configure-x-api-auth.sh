#!/bin/bash

# X API Authentication Configuration Script
# Use this when you already have working tokens and just need to configure them

echo "🔑 Configuring X API Authentication for NEARWEEK UserOwned.AI"
echo "==========================================================="

# Check if .env exists, create from example if not
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    if [ -f .env.example ]; then
        cp .env.example .env
    else
        echo "# UserOwned.AI Environment Configuration" > .env
        echo "" >> .env
    fi
fi

echo ""
echo "📋 Please enter your EXISTING X API credentials:"
echo "   (Click 'Reveal API Key hint' in X Developer Portal to see them)"
echo ""

# Collect existing credentials
read -p "🔑 API Key (from Consumer Keys section): " TWITTER_API_KEY
read -s -p "🔑 API Secret (from Consumer Keys section): " TWITTER_API_SECRET
echo ""

read -s -p "🎫 Bearer Token (from Authentication Tokens): " TWITTER_BEARER_TOKEN
echo ""

read -p "🎟️  Access Token (from Authentication Tokens): " TWITTER_ACCESS_TOKEN
read -s -p "🎟️  Access Token Secret (from Authentication Tokens): " TWITTER_ACCESS_TOKEN_SECRET
echo ""

# Validate token formats
echo ""
echo "🔍 Validating token formats..."

validate_token() {
    local name=$1
    local value=$2
    local min_length=$3
    
    if [ ${#value} -lt $min_length ]; then
        echo "⚠️  $name seems too short (${#value} chars, expected >$min_length)"
        return 1
    else
        echo "✅ $name format looks good (${#value} chars)"
        return 0
    fi
}

all_valid=true
validate_token "API Key" "$TWITTER_API_KEY" 20 || all_valid=false
validate_token "API Secret" "$TWITTER_API_SECRET" 40 || all_valid=false
validate_token "Bearer Token" "$TWITTER_BEARER_TOKEN" 100 || all_valid=false
validate_token "Access Token" "$TWITTER_ACCESS_TOKEN" 40 || all_valid=false
validate_token "Access Token Secret" "$TWITTER_ACCESS_TOKEN_SECRET" 40 || all_valid=false

if [ "$all_valid" = false ]; then
    echo ""
    echo "⚠️  Some tokens may be incomplete. Double-check them in X Developer Portal."
    read -p "Continue anyway? (y/N): " continue_choice
    if [ "$continue_choice" != "y" ] && [ "$continue_choice" != "Y" ]; then
        echo "Aborted. Please verify your tokens and try again."
        exit 1
    fi
fi

# Remove existing Twitter configuration
echo ""
echo "📝 Updating .env file..."
grep -v "^TWITTER_" .env > .env.tmp && mv .env.tmp .env

# Add new configuration
cat >> .env << EOF

# X (Twitter) API Authentication - Configured $(date)
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

# Feature flags
TWITTER_USE_V2_SEARCH=true
TWITTER_USE_V1_MEDIA=true
TWITTER_SMART_RATE_LIMITING=true

EOF

echo "✅ Configuration saved to .env"

# Test the authentication
echo ""
echo "🧪 Testing authentication..."
echo "=============================="

if command -v node >/dev/null 2>&1; then
    if [ -f "scripts/test-twitter-api-connection.js" ]; then
        node scripts/test-twitter-api-connection.js
    else
        echo "⚠️  Test script not found. Manual verification needed."
    fi
else
    echo "⚠️  Node.js not found. Install Node.js to test connection."
fi

echo ""
echo "🎉 Authentication Configuration Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Test connection: npm run api:test"
echo "2. Check quota: npm run api:status"  
echo "3. Start monitoring: npm run twitter:critical"
echo ""
echo "Your tokens:"
echo "- Generated: June 30, 2025"
echo "- Permissions: Read Only (correct for Basic tier)"
echo "- Monthly limit: 15,000 requests"
echo "- Daily limit: 500 requests"

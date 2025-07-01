#!/bin/bash

# X API Token Check Script - Verify existing tokens before regenerating
# This checks if your current tokens work before regenerating new ones

echo "🔍 Checking existing X API tokens for NEARWEEK UserOwned.AI"
echo "============================================================"

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ No .env file found. You need to set up credentials."
    echo "💡 Run: ./scripts/setup-x-api-credentials.sh"
    exit 1
fi

# Load environment variables
source .env

echo "📋 Current Token Status:"
echo "------------------------"

# Check each token
check_token() {
    local token_name=$1
    local token_value=$2
    local expected_length=$3
    
    if [ -z "$token_value" ] || [ "$token_value" = "your_${token_name,,}_here" ]; then
        echo "❌ $token_name: Missing or placeholder"
        return 1
    elif [ ${#token_value} -lt $expected_length ]; then
        echo "⚠️  $token_name: Present but seems too short (${#token_value} chars)"
        return 1
    else
        echo "✅ $token_name: Present (${#token_value} chars)"
        return 0
    fi
}

# Check all tokens
tokens_ok=true

check_token "TWITTER_API_KEY" "$TWITTER_API_KEY" 20 || tokens_ok=false
check_token "TWITTER_API_SECRET" "$TWITTER_API_SECRET" 40 || tokens_ok=false  
check_token "TWITTER_BEARER_TOKEN" "$TWITTER_BEARER_TOKEN" 100 || tokens_ok=false
check_token "TWITTER_ACCESS_TOKEN" "$TWITTER_ACCESS_TOKEN" 40 || tokens_ok=false
check_token "TWITTER_ACCESS_TOKEN_SECRET" "$TWITTER_ACCESS_TOKEN_SECRET" 40 || tokens_ok=false

echo ""

if [ "$tokens_ok" = true ]; then
    echo "🧪 Testing API connection with existing tokens..."
    echo "------------------------------------------------"
    
    # Test the connection
    if node scripts/test-twitter-api-connection.js; then
        echo ""
        echo "✅ EXISTING TOKENS WORK - NO NEED TO REGENERATE!"
        echo "🎉 You can proceed with:"
        echo "   npm run api:status"
        echo "   npm run twitter:critical"
        exit 0
    else
        echo ""
        echo "❌ Existing tokens failed connection test"
        echo "💡 Consider regenerating tokens in X Developer Portal"
    fi
else
    echo "⚠️  Some tokens are missing or invalid"
    echo "💡 Options:"
    echo "   1. Add missing tokens to .env manually"
    echo "   2. Run: ./scripts/setup-x-api-credentials.sh"
    echo "   3. Regenerate tokens in X Developer Portal if needed"
fi

echo ""
echo "🔄 If you want to regenerate tokens anyway:"
echo "   1. Go to X Developer Portal"
echo "   2. Click 'Regenerate' for any token you want to change"
echo "   3. Run: ./scripts/setup-x-api-credentials.sh"

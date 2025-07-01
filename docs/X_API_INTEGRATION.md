# X API Integration Commands for NEARWEEK UserOwned.AI

## Quick Setup
```bash
# 1. Clone and setup
git clone https://github.com/NEARWEEK/userowned.ai.git
cd userowned.ai
npm install

# 2. Setup X API credentials (regenerate all tokens first)
chmod +x scripts/setup-x-api-credentials.sh
./scripts/setup-x-api-credentials.sh

# 3. Test connection
npm run api:test
```

## Essential Commands

### API Connection & Testing
```bash
npm run api:status          # Check quota and limits
npm run api:test            # Test full API connection
npm run api:diagnose        # Troubleshoot issues
```

### Twitter Monitoring
```bash
npm run twitter:critical    # Monitor critical handles only
npm run twitter:real        # Full ecosystem monitoring
npm run twitter:mock        # Test with mock data
```

### Rate Limit Management
```bash
npm run quota:check         # Check current usage
npm run quota:reset         # Reset tracking (monthly)
```

### Development
```bash
npm run validate            # Validate setup
npm run test                # Run all tests
npm run logs                # View logs
```

## Configuration

### .env Required Variables
```
TWITTER_API_KEY=your_api_key
TWITTER_API_SECRET=your_api_secret  
TWITTER_BEARER_TOKEN=your_bearer_token
TWITTER_ACCESS_TOKEN=your_access_token
TWITTER_ACCESS_TOKEN_SECRET=your_access_secret

TWITTER_ENABLE_REAL_API=true
TWITTER_API_TIER=basic
TWITTER_MONTHLY_LIMIT=15000
TWITTER_DAILY_LIMIT=500
```

## Troubleshooting

### 403 Errors
- Verify Basic tier limits
- Check endpoint availability
- Confirm app permissions

### 429 Rate Limits  
- Check daily/monthly quotas
- Increase delay between requests
- Reduce monitoring frequency

### Authentication Issues
- Regenerate all tokens
- Verify .env file format
- Check token permissions

## Basic Tier Limitations
- No user timeline access
- 15,000 requests/month
- 500 requests/day  
- Search API only for user content
- Read-only access primarily

## Monitoring Strategy
- Critical handles: 3x daily
- High priority: 1x daily
- Medium/Low: Weekly
- Profile changes: Real-time

# Twitter API Setup Instructions

## Steps to Enable X Content Monitoring

### 1. Apply for X Developer Account
- Go to: https://developer.twitter.com/en/portal/dashboard
- Sign in with @userownedai credentials
- Apply for developer access

### 2. Application Details
```
Use case: Automated newsletter generation and content curation
Description: Weekly AI x Crypto newsletter monitoring followed accounts
Will analyze Twitter data: Yes - for content relevance
External display: Yes - newsletter format
Commercial use: No - informational
```

### 3. Choose Plan
- **Recommended**: Basic ($100/month)
- **Includes**: Following list access + tweet content

### 4. Create App
- Project: "UserOwned AI Newsletter"
- App: "Weekly Newsletter Bot"
- Permissions: Read-only
- Generate Bearer Token

### 5. Add to GitHub Secrets
```
Name: TWITTER_BEARER_TOKEN
Value: Your Bearer Token from Developer Portal
```

### 6. Test Access
```bash
curl -X GET "https://api.twitter.com/2/users/by/username/userownedai" \
  -H "Authorization: Bearer YOUR_BEARER_TOKEN"
```

### 7. Enhanced Features
Once API is enabled:
- Monitor accounts @userownedai follows
- Filter for AI x Crypto content
- Rank by engagement metrics
- Auto-categorize into newsletter sections

### Current Status
- ✅ Weekly newsletter automation ready
- ⏳ Waiting for Twitter API access
- ✅ GitHub data sources working
- ✅ Telegram and X posting functional

The newsletter works with GitHub data only until Twitter API is configured.
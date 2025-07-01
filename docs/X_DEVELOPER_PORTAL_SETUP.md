# X Developer Portal Configuration Guide for NEARWEEK UserOwned.AI

## App Settings Configuration

### 1. App Permissions
**Recommended:** Read and write
- ✅ Read Posts and profile information  
- ✅ Post Posts and profile information
- ❌ Direct message (not needed for NEARWEEK use case)

**Why Read and write:**
- Enables posting NEARWEEK intelligence updates
- Allows automated newsletter posting
- Supports community engagement
- Basic "Read" limits monitoring capabilities

### 2. Type of App
**Keep:** Web App, Automated App or Bot
- ✅ Confidential client (correct for server-side app)

### 3. Required URLs Setup

#### Callback URI / Redirect URL
```
https://userowned.ai/auth/callback
https://localhost:3000/auth/callback
```

#### Website URL
```
https://userowned.ai
```

#### Organization name
```
NEARWEEK
```

#### Organization URL  
```
https://nearweek.com
```

#### Terms of service
```
https://nearweek.com/terms
```

#### Privacy policy
```
https://nearweek.com/privacy
```

## Configuration Steps

### Step 1: Update App Permissions
1. Change from "Read" to "Read and write"
2. Leave "Request email" unchecked (not needed)
3. Save changes

### Step 2: Fill Required URLs
1. Add callback URLs (userowned.ai domain + localhost for dev)
2. Add website URL
3. Add organization info
4. Add terms/privacy URLs

### Step 3: Regenerate Tokens (Required After Permission Change)
**Important:** Changing permissions requires new tokens
1. Regenerate Bearer Token
2. Regenerate Access Token and Secret
3. Keep API Key/Secret (may not change)

## Impact of Changes

### New Capabilities
- ✅ Post tweets via API
- ✅ Upload media content
- ✅ Reply to mentions
- ✅ Enhanced monitoring

### Rate Limits (Basic Tier)
- Monthly: 15,000 requests (unchanged)
- Daily: 500 requests (unchanged)
- Write operations: Count toward limits

## Alternative: Keep Read-Only
If you only need monitoring:
- Keep current "Read" permissions
- Just add required URLs
- No token regeneration needed
- Focus on data collection only

## Recommendation for NEARWEEK
**Upgrade to Read and write** because:
1. Enables automated posting of intelligence updates
2. Allows community engagement via API
3. Supports full newsletter automation
4. Future-proofs for content distribution

The additional write permissions unlock significant value for NEARWEEK's automation goals.

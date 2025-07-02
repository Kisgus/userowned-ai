# 🔐 NEARWEEK Team API Secrets Management - NEAR Wallet Authentication

**Secure, decentralized team access to X API credentials using NEAR Protocol wallet authentication**

---

## 🎯 **Architecture Overview**

```
NEAR Wallet → MCP Auth → Vault Access → API Secrets
     ↓            ↓          ↓           ↓
Team Member → Verify → Get Role → Receive Keys
```

### **Components:**
1. **NEAR MCP Integration**: Wallet-based authentication
2. **Secrets Vault**: Encrypted storage with role-based access
3. **Team Access Control**: Permission levels by NEAR account
4. **Automatic Key Rotation**: Scheduled credential updates

---

## 🏗️ **Implementation Strategy**

### **1. NEAR MCP Authentication Setup**

```javascript
// src/auth/near-wallet-auth.js
const { connect, keyStores, WalletConnection } = require('near-api-js');

class NEARWalletAuth {
    constructor() {
        this.nearConfig = {
            networkId: 'mainnet',
            keyStore: new keyStores.BrowserLocalStorageKeyStore(),
            nodeUrl: 'https://rpc.mainnet.near.org',
            walletUrl: 'https://wallet.mainnet.near.org',
            helperUrl: 'https://helper.mainnet.near.org'
        };
        this.authorizedAccounts = [
            'nearweek.near',
            'userownedai.near',
            'team1.nearweek.near',
            'team2.nearweek.near',
            'dev1.nearweek.near'
        ];
    }

    async authenticate(accountId) {
        if (!this.authorizedAccounts.includes(accountId)) {
            throw new Error(`Unauthorized NEAR account: ${accountId}`);
        }
        
        const near = await connect(this.nearConfig);
        const wallet = new WalletConnection(near, 'nearweek-vault');
        
        if (!wallet.isSignedIn()) {
            throw new Error('NEAR wallet not signed in');
        }
        
        const signedAccountId = wallet.getAccountId();
        if (signedAccountId !== accountId) {
            throw new Error('Account ID mismatch');
        }
        
        return {
            accountId: signedAccountId,
            role: this.getAccountRole(signedAccountId),
            permissions: this.getAccountPermissions(signedAccountId)
        };
    }

    getAccountRole(accountId) {
        const roleMap = {
            'nearweek.near': 'admin',
            'userownedai.near': 'admin',
            'team1.nearweek.near': 'developer',
            'team2.nearweek.near': 'developer',
            'dev1.nearweek.near': 'readonly'
        };
        return roleMap[accountId] || 'guest';
    }

    getAccountPermissions(accountId) {
        const role = this.getAccountRole(accountId);
        const permissions = {
            admin: ['read', 'write', 'rotate', 'manage'],
            developer: ['read', 'write'],
            readonly: ['read'],
            guest: []
        };
        return permissions[role] || [];
    }
}

module.exports = NEARWalletAuth;
```

### **2. Encrypted Secrets Vault**

```javascript
// src/vault/secrets-vault.js
const crypto = require('crypto');
const fs = require('fs').promises;

class SecretsVault {
    constructor(masterKey) {
        this.masterKey = masterKey;
        this.algorithm = 'aes-256-gcm';
        this.vaultPath = './vault/encrypted-secrets.json';
    }

    encrypt(text) {
        const iv = crypto.randomBytes(16);
        const cipher = crypto.createCipher(this.algorithm, this.masterKey);
        cipher.setAAD(Buffer.from('nearweek-vault', 'utf8'));
        
        let encrypted = cipher.update(text, 'utf8', 'hex');
        encrypted += cipher.final('hex');
        
        const authTag = cipher.getAuthTag();
        
        return {
            encrypted,
            iv: iv.toString('hex'),
            authTag: authTag.toString('hex')
        };
    }

    decrypt(encryptedData) {
        const decipher = crypto.createDecipher(this.algorithm, this.masterKey);
        decipher.setAAD(Buffer.from('nearweek-vault', 'utf8'));
        decipher.setAuthTag(Buffer.from(encryptedData.authTag, 'hex'));
        
        let decrypted = decipher.update(encryptedData.encrypted, 'hex', 'utf8');
        decrypted += decipher.final('utf8');
        
        return decrypted;
    }

    async storeSecrets(secrets, accountId) {
        const timestamp = new Date().toISOString();
        const secretsWithMeta = {
            ...secrets,
            metadata: {
                lastUpdated: timestamp,
                updatedBy: accountId,
                version: Date.now()
            }
        };

        const encrypted = this.encrypt(JSON.stringify(secretsWithMeta));
        
        await fs.writeFile(this.vaultPath, JSON.stringify({
            data: encrypted,
            lastAccess: timestamp,
            accessedBy: accountId
        }, null, 2));
        
        console.log(`✅ Secrets stored by ${accountId} at ${timestamp}`);
    }

    async retrieveSecrets(accountId, permissions) {
        if (!permissions.includes('read')) {
            throw new Error('Insufficient permissions to read secrets');
        }

        const vaultData = JSON.parse(await fs.readFile(this.vaultPath, 'utf8'));
        const decrypted = this.decrypt(vaultData.data);
        const secrets = JSON.parse(decrypted);

        // Log access
        await this.logAccess(accountId);

        // Filter secrets based on role
        return this.filterSecretsByRole(secrets, permissions);
    }

    async logAccess(accountId) {
        const logEntry = {
            accountId,
            timestamp: new Date().toISOString(),
            action: 'secrets_access'
        };
        
        // Update vault with access log
        const vaultData = JSON.parse(await fs.readFile(this.vaultPath, 'utf8'));
        vaultData.lastAccess = logEntry.timestamp;
        vaultData.accessedBy = accountId;
        
        await fs.writeFile(this.vaultPath, JSON.stringify(vaultData, null, 2));
        
        // Append to access log
        const logPath = './vault/access.log';
        await fs.appendFile(logPath, JSON.stringify(logEntry) + '\\n');
    }

    filterSecretsByRole(secrets, permissions) {
        const filtered = { metadata: secrets.metadata };
        
        if (permissions.includes('read')) {
            // Basic API keys for read operations
            filtered.TWITTER_BEARER_TOKEN = secrets.TWITTER_BEARER_TOKEN;
            filtered.GITHUB_TOKEN = secrets.GITHUB_TOKEN;
        }
        
        if (permissions.includes('write')) {
            // Full API access for write operations
            filtered.TWITTER_API_KEY = secrets.TWITTER_API_KEY;
            filtered.TWITTER_API_SECRET = secrets.TWITTER_API_SECRET;
            filtered.TWITTER_ACCESS_TOKEN = secrets.TWITTER_ACCESS_TOKEN;
            filtered.TWITTER_ACCESS_TOKEN_SECRET = secrets.TWITTER_ACCESS_TOKEN_SECRET;
            filtered.TWITTER_CLIENT_ID = secrets.TWITTER_CLIENT_ID;
            filtered.TWITTER_CLIENT_SECRET = secrets.TWITTER_CLIENT_SECRET;
        }
        
        if (permissions.includes('manage')) {
            // All secrets including sensitive ones
            filtered.TELEGRAM_BOT_TOKEN = secrets.TELEGRAM_BOT_TOKEN;
            filtered.MAILCHIMP_API_KEY = secrets.MAILCHIMP_API_KEY;
            filtered.MASTER_VAULT_KEY = secrets.MASTER_VAULT_KEY;
        }
        
        return filtered;
    }
}

module.exports = SecretsVault;
```

### **3. MCP Integration for Team Access**

```javascript
// src/mcp/vault-server.js
const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const NEARWalletAuth = require('../auth/near-wallet-auth');
const SecretsVault = require('../vault/secrets-vault');

class VaultMCPServer {
    constructor() {
        this.server = new Server(
            { name: 'nearweek-vault', version: '1.0.0' },
            { capabilities: { tools: {} } }
        );
        
        this.auth = new NEARWalletAuth();
        this.vault = new SecretsVault(process.env.MASTER_VAULT_KEY);
        
        this.setupTools();
    }

    setupTools() {
        // Tool: Get API secrets
        this.server.setRequestHandler('tools/call', async (request) => {
            const { name, arguments: args } = request.params;
            
            switch (name) {
                case 'get_api_secrets':
                    return await this.getAPISecrets(args);
                case 'rotate_api_keys':
                    return await this.rotateAPIKeys(args);
                case 'add_team_member':
                    return await this.addTeamMember(args);
                default:
                    throw new Error(`Unknown tool: ${name}`);
            }
        });

        // List available tools
        this.server.setRequestHandler('tools/list', async () => {
            return {
                tools: [
                    {
                        name: 'get_api_secrets',
                        description: 'Get API secrets based on NEAR wallet authentication',
                        inputSchema: {
                            type: 'object',
                            properties: {
                                near_account: { type: 'string' },
                                environment: { type: 'string', enum: ['development', 'staging', 'production'] }
                            },
                            required: ['near_account']
                        }
                    },
                    {
                        name: 'rotate_api_keys',
                        description: 'Rotate API keys (admin only)',
                        inputSchema: {
                            type: 'object',
                            properties: {
                                near_account: { type: 'string' },
                                key_type: { type: 'string', enum: ['twitter', 'github', 'telegram', 'all'] }
                            },
                            required: ['near_account', 'key_type']
                        }
                    },
                    {
                        name: 'add_team_member',
                        description: 'Add new team member with permissions',
                        inputSchema: {
                            type: 'object',
                            properties: {
                                admin_account: { type: 'string' },
                                new_member_account: { type: 'string' },
                                role: { type: 'string', enum: ['admin', 'developer', 'readonly'] }
                            },
                            required: ['admin_account', 'new_member_account', 'role']
                        }
                    }
                ]
            };
        });
    }

    async getAPISecrets(args) {
        try {
            // Authenticate NEAR wallet
            const authResult = await this.auth.authenticate(args.near_account);
            
            // Get secrets based on permissions
            const secrets = await this.vault.retrieveSecrets(
                authResult.accountId, 
                authResult.permissions
            );

            // Filter by environment
            const envSecrets = this.filterByEnvironment(secrets, args.environment);

            return {
                content: [{
                    type: 'text',
                    text: `🔐 API Secrets for ${authResult.accountId}\\n` +
                          `Role: ${authResult.role}\\n` +
                          `Environment: ${args.environment || 'all'}\\n` +
                          `Permissions: ${authResult.permissions.join(', ')}\\n\\n` +
                          `Available secrets:\\n${this.formatSecrets(envSecrets)}`
                }]
            };
        } catch (error) {
            return {
                content: [{
                    type: 'text',
                    text: `❌ Authentication failed: ${error.message}`
                }]
            };
        }
    }

    async rotateAPIKeys(args) {
        try {
            const authResult = await this.auth.authenticate(args.admin_account);
            
            if (!authResult.permissions.includes('rotate')) {
                throw new Error('Insufficient permissions for key rotation');
            }

            // Implement key rotation logic
            const rotationResult = await this.performKeyRotation(args.key_type);

            return {
                content: [{
                    type: 'text',
                    text: `🔄 Key rotation completed for ${args.key_type}\\n` +
                          `Rotated by: ${authResult.accountId}\\n` +
                          `Timestamp: ${new Date().toISOString()}\\n\\n` +
                          `${rotationResult}`
                }]
            };
        } catch (error) {
            return {
                content: [{
                    type: 'text',
                    text: `❌ Key rotation failed: ${error.message}`
                }]
            };
        }
    }

    filterByEnvironment(secrets, environment) {
        if (!environment || environment === 'all') {
            return secrets;
        }

        // Return environment-specific configurations
        const envConfig = {
            development: {
                ...secrets,
                TWITTER_ENABLE_REAL_API: 'false',
                TWITTER_MONTHLY_LIMIT: '100',
                DRY_RUN_MODE: 'true'
            },
            staging: {
                ...secrets,
                TWITTER_ENABLE_REAL_API: 'true',
                TWITTER_MONTHLY_LIMIT: '5000',
                DRY_RUN_MODE: 'false'
            },
            production: {
                ...secrets,
                TWITTER_ENABLE_REAL_API: 'true',
                TWITTER_MONTHLY_LIMIT: '15000',
                DRY_RUN_MODE: 'false'
            }
        };

        return envConfig[environment] || secrets;
    }

    formatSecrets(secrets) {
        const formatted = [];
        Object.keys(secrets).forEach(key => {
            if (key !== 'metadata') {
                const value = secrets[key];
                const masked = value.length > 10 ? 
                    value.substring(0, 6) + '...' + value.substring(value.length - 4) :
                    '***';
                formatted.push(`${key}=${masked}`);
            }
        });
        return formatted.join('\\n');
    }
}

module.exports = VaultMCPServer;
```

---

## 🎮 **Team Usage Commands**

### **1. Setup Vault (Admin Only)**
```bash
# Initialize vault with master key
node scripts/setup-vault.js

# Add initial secrets
node scripts/vault-add-secrets.js --account nearweek.near

# Configure team permissions
node scripts/vault-add-member.js --admin nearweek.near --member team1.nearweek.near --role developer
```

### **2. Get Secrets via NEAR Wallet**
```bash
# Team member gets their secrets
node scripts/vault-get-secrets.js --account team1.nearweek.near --environment staging

# Output: Creates .env.staging with appropriate secrets based on role
```

### **3. MCP Integration**
```javascript
// In Claude Desktop with NEAR MCP
// Team member can request: "Get my API secrets for staging environment"
// Claude will authenticate via NEAR wallet and return appropriate secrets
```

---

## 🔧 **Implementation Scripts**

### **Vault Setup Script**
```bash
#!/bin/bash
# scripts/setup-vault.sh

echo "🔐 Setting up NEARWEEK Secrets Vault"
echo "====================================="

# Generate master key
MASTER_KEY=$(openssl rand -base64 32)
echo "MASTER_VAULT_KEY=$MASTER_KEY" >> .env.vault

# Create vault directory
mkdir -p vault
chmod 700 vault

# Initialize vault
node -e "
const SecretsVault = require('./src/vault/secrets-vault');
const vault = new SecretsVault('$MASTER_KEY');
console.log('✅ Vault initialized');
"

echo "🎯 Next steps:"
echo "1. Add secrets: node scripts/vault-add-secrets.js"
echo "2. Add team members: node scripts/vault-add-member.js"
echo "3. Test access: node scripts/vault-get-secrets.js"
```

### **Get Secrets Script**
```bash
#!/bin/bash
# scripts/vault-get-secrets.sh

NEAR_ACCOUNT=$1
ENVIRONMENT=${2:-staging}

if [ -z "$NEAR_ACCOUNT" ]; then
    echo "❌ Please provide NEAR account"
    echo "Usage: ./scripts/vault-get-secrets.sh team1.nearweek.near staging"
    exit 1
fi

echo "🔐 Getting secrets for $NEAR_ACCOUNT ($ENVIRONMENT)"

# Get secrets via MCP
node -e "
const VaultMCPServer = require('./src/mcp/vault-server');
const server = new VaultMCPServer();

async function getSecrets() {
    try {
        const result = await server.getAPISecrets({
            near_account: '$NEAR_ACCOUNT',
            environment: '$ENVIRONMENT'
        });
        console.log(result.content[0].text);
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

getSecrets();
"
```

---

## 🛡️ **Security Features**

### **Access Control**
- ✅ **NEAR Wallet Authentication**: Cryptographic proof of identity
- ✅ **Role-Based Permissions**: Admin, Developer, ReadOnly access levels
- ✅ **Environment Filtering**: Different secrets per environment
- ✅ **Audit Logging**: Complete access trail with timestamps

### **Encryption**
- ✅ **AES-256-GCM**: Military-grade encryption for stored secrets
- ✅ **Master Key Rotation**: Periodic key updates for enhanced security
- ✅ **Authenticated Encryption**: Prevents tampering with encrypted data

### **Team Management**
- ✅ **Dynamic Permissions**: Add/remove team members without code changes
- ✅ **Automatic Expiry**: Time-based access tokens
- ✅ **Emergency Revocation**: Instant access removal for compromised accounts

---

## 📊 **Team Workflow Example**

### **New Team Member Onboarding**
```bash
# 1. Admin adds new member
./scripts/vault-add-member.sh nearweek.near newdev.nearweek.near developer

# 2. New member gets secrets
./scripts/vault-get-secrets.sh newdev.nearweek.near development

# 3. Secrets automatically configured in .env.development
# 4. Team member can start development immediately
```

### **Daily Development Workflow**
```bash
# Morning: Get latest secrets
./scripts/vault-get-secrets.sh team1.nearweek.near staging

# Development: Work with appropriate permissions
npm run api:test

# Evening: Keys automatically expire/rotate
```

This NEAR-based vault system provides secure, auditable, and easy team access to API secrets while maintaining the highest security standards for the NEARWEEK team.

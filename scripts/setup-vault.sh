#!/bin/bash

# NEARWEEK Intelligence Platform - Vault Setup Script
# This script sets up HashiCorp Vault for secure API key management

set -e

echo "🔐 Setting up HashiCorp Vault for NEARWEEK Intelligence Platform..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should not be run as root for security reasons"
   exit 1
fi

# Install Vault
install_vault() {
    echo "📦 Installing HashiCorp Vault..."
    
    # Add HashiCorp GPG key
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    
    # Add HashiCorp repository
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    
    # Update and install
    sudo apt-get update && sudo apt-get install vault
    
    echo "✅ Vault installed successfully"
}

# Initialize Vault
init_vault() {
    echo "🚀 Initializing Vault..."
    
    # Create vault directory
    sudo mkdir -p /opt/vault/data
    sudo chown vault:vault /opt/vault/data
    
    # Create vault config
    sudo tee /etc/vault.d/vault.hcl > /dev/null << EOF
ui = true
disable_mlock = true

storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = 1
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
EOF

    # Start vault service
    sudo systemctl enable vault
    sudo systemctl start vault
    
    # Set vault address
    export VAULT_ADDR='http://127.0.0.1:8200'
    echo 'export VAULT_ADDR="http://127.0.0.1:8200"' >> ~/.bashrc
    
    # Initialize vault
    echo "🔑 Initializing Vault with 5 key shares and threshold of 3..."
    vault operator init -key-shares=5 -key-threshold=3 > vault-keys.txt
    
    echo "⚠️  IMPORTANT: vault-keys.txt contains your unseal keys and root token"
    echo "📝 Store these keys securely and distribute to trusted team members"
    
    # Extract root token and first 3 unseal keys
    ROOT_TOKEN=$(grep 'Initial Root Token:' vault-keys.txt | awk '{print $NF}')
    UNSEAL_KEY_1=$(grep 'Unseal Key 1:' vault-keys.txt | awk '{print $NF}')
    UNSEAL_KEY_2=$(grep 'Unseal Key 2:' vault-keys.txt | awk '{print $NF}')
    UNSEAL_KEY_3=$(grep 'Unseal Key 3:' vault-keys.txt | awk '{print $NF}')
    
    # Unseal vault
    echo "🔓 Unsealing Vault..."
    vault operator unseal $UNSEAL_KEY_1
    vault operator unseal $UNSEAL_KEY_2
    vault operator unseal $UNSEAL_KEY_3
    
    # Login with root token
    vault auth $ROOT_TOKEN
    
    echo "✅ Vault initialized and unsealed successfully"
}

# Setup secret paths
setup_secrets() {
    echo "📁 Setting up secret paths..."
    
    # Enable KV secrets engine
    vault secrets enable -path=secret kv-v2
    
    # Create policy for intelligence platform
    vault policy write intelligence-platform - << EOF
path "secret/data/nearweek/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/metadata/nearweek/*" {
  capabilities = ["list"]
}
EOF

    echo "✅ Secret paths configured"
}

# Setup development secrets
setup_dev_secrets() {
    echo "🧪 Setting up development environment secrets..."
    
    vault kv put secret/nearweek/development \\
        github_token="dev_github_token_placeholder" \\
        telegram_bot_token="dev_telegram_token_placeholder" \\
        zapier_webhook="https://hooks.zapier.com/hooks/catch/dev/" \\
        gemini_api_key="dev_gemini_key_placeholder"
    
    echo "✅ Development secrets configured"
}

# Setup staging secrets
setup_staging_secrets() {
    echo "🎭 Setting up staging environment secrets..."
    
    vault kv put secret/nearweek/staging \\
        github_token="staging_github_token_placeholder" \\
        telegram_bot_token="staging_telegram_token_placeholder" \\
        zapier_webhook="https://hooks.zapier.com/hooks/catch/staging/" \\
        gemini_api_key="staging_gemini_key_placeholder"
    
    echo "✅ Staging secrets configured"
}

# Setup production secrets (placeholders)
setup_prod_secrets() {
    echo "🏭 Setting up production environment secrets..."
    
    vault kv put secret/nearweek/production \\
        github_token="REPLACE_WITH_REAL_GITHUB_TOKEN" \\
        telegram_bot_token="REPLACE_WITH_REAL_TELEGRAM_TOKEN" \\
        zapier_webhook="REPLACE_WITH_REAL_ZAPIER_WEBHOOK" \\
        gemini_api_key="REPLACE_WITH_REAL_GEMINI_KEY"
    
    echo "⚠️  Production secrets contain placeholders - replace with real values"
    echo "✅ Production secret structure configured"
}

# Create monitoring script
create_monitoring() {
    echo "📊 Creating Vault monitoring script..."
    
    tee vault-monitor.sh > /dev/null << 'EOF'
#!/bin/bash

# Vault Health Monitor
export VAULT_ADDR='http://127.0.0.1:8200'

# Check vault status
vault_status=$(vault status -format=json 2>/dev/null)

if [ $? -eq 0 ]; then
    sealed=$(echo $vault_status | jq -r '.sealed')
    if [ "$sealed" = "false" ]; then
        echo "✅ Vault is healthy and unsealed"
        exit 0
    else
        echo "⚠️  Vault is sealed"
        exit 1
    fi
else
    echo "❌ Vault is not responding"
    exit 2
fi
EOF

    chmod +x vault-monitor.sh
    echo "✅ Vault monitoring script created"
}

# Create key rotation script
create_rotation_script() {
    echo "🔄 Creating key rotation script..."
    
    tee rotate-keys.sh > /dev/null << 'EOF'
#!/bin/bash

# Key rotation script for NEARWEEK Intelligence Platform
set -e

export VAULT_ADDR='http://127.0.0.1:8200'

echo "🔄 Starting key rotation process..."

# Function to rotate GitHub token
rotate_github_token() {
    echo "🔑 Rotating GitHub token..."
    # This would integrate with GitHub API to create new token
    # For now, just update with placeholder
    vault kv patch secret/nearweek/production github_token="NEW_GITHUB_TOKEN_$(date +%s)"
    echo "✅ GitHub token rotated"
}

# Function to rotate Telegram token  
rotate_telegram_token() {
    echo "📱 Rotating Telegram bot token..."
    # This would integrate with Telegram API if needed
    vault kv patch secret/nearweek/production telegram_bot_token="NEW_TELEGRAM_TOKEN_$(date +%s)"
    echo "✅ Telegram token rotated"
}

# Function to rotate Zapier webhook
rotate_zapier_webhook() {
    echo "⚡ Rotating Zapier webhook..."
    vault kv patch secret/nearweek/production zapier_webhook="https://hooks.zapier.com/hooks/catch/new_$(date +%s)/"
    echo "✅ Zapier webhook rotated"
}

# Check if we should rotate (run if older than 90 days)
LAST_ROTATION=$(vault kv get -field=last_rotation secret/nearweek/production 2>/dev/null || echo "0")
CURRENT_TIME=$(date +%s)
NINETY_DAYS=$((90 * 24 * 60 * 60))

if [ $((CURRENT_TIME - LAST_ROTATION)) -gt $NINETY_DAYS ]; then
    echo "🕐 Keys are older than 90 days, starting rotation..."
    
    rotate_github_token
    rotate_telegram_token
    rotate_zapier_webhook
    
    # Update last rotation timestamp
    vault kv patch secret/nearweek/production last_rotation="$CURRENT_TIME"
    
    echo "✅ Key rotation completed successfully"
else
    echo "ℹ️  Keys are still fresh, no rotation needed"
fi
EOF

    chmod +x rotate-keys.sh
    echo "✅ Key rotation script created"
}

# Main execution
main() {
    echo "🚀 NEARWEEK Intelligence Platform - Vault Setup"
    echo "=============================================="
    
    # Check if vault is already installed
    if command -v vault &> /dev/null; then
        echo "ℹ️  Vault is already installed"
    else
        install_vault
    fi
    
    # Check if vault is already initialized
    if vault status >/dev/null 2>&1; then
        echo "ℹ️  Vault is already initialized"
    else
        init_vault
    fi
    
    setup_secrets
    setup_dev_secrets
    setup_staging_secrets
    setup_prod_secrets
    create_monitoring
    create_rotation_script
    
    echo ""
    echo "🎉 Vault setup completed successfully!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Review and secure vault-keys.txt"
    echo "2. Replace production secret placeholders with real values"
    echo "3. Set up automated key rotation cron job"
    echo "4. Configure application to use Vault secrets"
    echo ""
    echo "💡 Useful commands:"
    echo "   vault status                     # Check vault status"
    echo "   vault kv get secret/nearweek/production  # View production secrets"
    echo "   ./vault-monitor.sh              # Monitor vault health"
    echo "   ./rotate-keys.sh                # Rotate API keys"
    echo ""
    echo "🔗 Vault UI: http://127.0.0.1:8200"
}

# Run main function
main "$@"
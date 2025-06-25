# GitHub Actions Workflow Directory

This directory contains the automated workflow for daily AI x Crypto updates.

## Workflow Files:
- `daily-update.yml` - Automated daily updates to Telegram and X/Twitter

## Setup:
The workflow uses the following secrets:
- `TELEGRAM_BOT_TOKEN` - Bot token for @ai_x_cryptobot  
- `ZAPIER_WEBHOOK_URL` - Webhook URL for Zapier → Buffer → X integration

## Schedule:
Runs daily at 9:00 AM UTC automatically.

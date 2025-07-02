#!/usr/bin/env node

// X API Keys Test - Quick Validation
require('dotenv').config();

console.log('🔑 X API Keys Test');
console.log('==================');

const keys = [
    'TWITTER_API_KEY',
    'TWITTER_API_SECRET', 
    'TWITTER_BEARER_TOKEN',
    'TWITTER_ACCESS_TOKEN',
    'TWITTER_ACCESS_TOKEN_SECRET',
    'TWITTER_CLIENT_ID',
    'TWITTER_CLIENT_SECRET'
];

keys.forEach(key => {
    const value = process.env[key];
    if (value && value.length > 10) {
        console.log(`✅ ${key}: ${value.length} chars`);
    } else {
        console.log(`❌ ${key}: Missing`);
    }
});

// Test Bearer Token
async function testBearer() {
    try {
        const { TwitterApi } = require('twitter-api-v2');
        const client = new TwitterApi(process.env.TWITTER_BEARER_TOKEN);
        const result = await client.v2.search('hello', { max_results: 5 });
        console.log('✅ Bearer Token works:', result.data?.length, 'tweets');
    } catch (e) {
        console.log('❌ Bearer Token failed:', e.message);
    }
}

testBearer();

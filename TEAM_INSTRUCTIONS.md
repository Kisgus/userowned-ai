# 📋 NEARWEEK Team Instructions: Airtable → AI Content → Buffer Workflow

**Process Overview:** Airtable Input → OpenAI Content & Terminal Image → Buffer Queue → Team Review → @userownedai X Post

---

## 🎯 **Quick Start for Team Members**

### **Step 1: Add Content to Airtable**
1. **Open Airtable Base**: [NEARWEEK/USEROWNED.AI](https://airtable.com/appOhxK8fCNLsjQAa/tbljh8tKM0mlewFDE/viw5abNlYPtOnOG5S?blocks=hide)
2. **Click "+ Add Record"** in the content table
3. **Fill Required Fields**:

| Field Name | What to Enter | Example |
|------------|---------------|---------|
| **Content Type** | Select: `Intelligence Alert`, `Weekly Update`, `Ecosystem Analysis`, `Breaking News` | `Intelligence Alert` |
| **Title** | Brief headline (max 60 chars) | `NEAR Protocol AI Partnership` |
| **Key Points** | 3-5 bullet points of main information | `• Partnership with OpenAI announced`<br>`• Focus on decentralized AI infrastructure`<br>`• $10M funding commitment` |
| **Source URL** | Link to original announcement/news | `https://near.org/blog/ai-partnership` |
| **Priority** | Select: `High`, `Medium`, `Low` | `High` |
| **Target Audience** | Select: `Developers`, `Investors`, `General`, `Enterprise` | `Investors` |
| **Trigger Automation** | ✅ Check this box to start the process | ✅ |

### **Step 2: Save and Wait for Automation**
- **Click "Save"** - automation triggers immediately
- **Processing Time**: 2-3 minutes for content + image generation
- **Status Updates**: Watch the "Automation Status" field

---

## 🤖 **What Happens Automatically**

### **Phase 1: Content Generation (60 seconds)**
```
Airtable → Zapier → OpenAI GPT-4
```
**AI generates:**
- ✅ **Tweet Content**: Optimized for X platform (280 chars)
- ✅ **Thread Content**: Multi-tweet breakdown if needed
- ✅ **Hashtags**: Relevant #NEARWEEK #UserOwnedAI tags
- ✅ **Engagement Hook**: Compelling opening line

### **Phase 2: Visual Generation (90 seconds)**
```
Content → DALL-E 3 → Terminal Interface Image
```
**AI creates:**
- ✅ **NEARWEEK Terminal**: Dark theme with neon green accents
- ✅ **Live Data Display**: Shows the content as "incoming intelligence"
- ✅ **NEARWEEK Logo**: Prominently displayed
- ✅ **Professional Aesthetic**: Bloomberg terminal style
- ✅ **1280x720 Resolution**: Optimized for X

### **Phase 3: Queue for Review (30 seconds)**
```
Content + Image → Buffer → Team Review Queue
```
**Automatically:**
- ✅ **Uploads to Buffer**: Content + image attached
- ✅ **Sets to Draft**: Requires manual approval
- ✅ **Tags Team**: Notification sent
- ✅ **Updates Airtable**: Status changes to "Pending Review"

---

## 👥 **Team Review Process**

### **Step 1: Receive Notification**
- **Slack Alert**: "@channel New content ready for review"
- **Email**: Buffer notification to team
- **Airtable**: Status shows "Pending Review"

### **Step 2: Review in Buffer**
1. **Open Buffer Dashboard**: [buffer.com/publish](https://buffer.com/publish)
2. **Navigate to**: `just_deployed X Free Profile` queue
3. **Find**: Latest draft post with NEARWEEK terminal image

### **Step 3: Review Checklist**
- ✅ **Content Accuracy**: Facts are correct
- ✅ **Brand Voice**: Sounds like NEARWEEK
- ✅ **Visual Quality**: Terminal image looks professional
- ✅ **Hashtags**: Appropriate tags included
- ✅ **Character Count**: Under 280 characters
- ✅ **Link Check**: Source URL works

### **Step 4: Approve or Edit**
**Option A: Approve & Post**
- Click "Share Now" in Buffer
- Content goes live immediately
- Airtable status updates to "Published"

**Option B: Edit & Reschedule**
- Click "Edit" in Buffer
- Make necessary changes
- Set posting time
- Save changes

**Option C: Reject**
- Click "Delete" in Buffer
- Add rejection reason in Airtable
- Status updates to "Rejected"

---

## 🎨 **Visual Style Examples**

### **Terminal Interface Design:**
```
┌─────────────────────────────────────────────────┐
│ [NEARWEEK] INTELLIGENCE TERMINAL v2.1          │
├─────────────────────────────────────────────────┤
│ ⚡ REAL-TIME ALERT                              │
│                                                 │
│ 🎯 NEAR Protocol AI Partnership Announced      │
│                                                 │
│ 📊 KEY DATA:                                   │
│ • Partnership: NEAR + OpenAI                   │
│ • Investment: $10M commitment                  │
│ • Focus: Decentralized AI infrastructure       │
│ • Timeline: Q1 2025 deployment                 │
│                                                 │
│ 🔍 IMPACT ANALYSIS: [████████░░] 87% Positive  │
│                                                 │
│ [NEARWEEK] The Bloomberg Terminal for AI×Crypto │
└─────────────────────────────────────────────────┘
```

### **Content Style Examples:**

**Intelligence Alert:**
```
🚨 INTELLIGENCE ALERT

🎯 NEAR Protocol announces strategic AI partnership with OpenAI

📊 Key Details:
• $10M funding commitment
• Decentralized AI infrastructure focus
• Q1 2025 deployment timeline

Impact: Significant momentum for AI×crypto convergence.

#NEARWEEK #UserOwnedAI #AI #NEAR
```

**Ecosystem Analysis:**
```
📈 ECOSYSTEM PULSE

🔍 8 AI×crypto protocols analyzed this week:

📊 Performance Leaders:
• NEAR: +12.3% dev activity
• Bittensor: +8.7% network growth  
• ICP: +15.2% AI deployments

🎯 Trend: Infrastructure-focused projects gaining traction.

#NEARWEEK #CryptoIntelligence
```

---

## ⚙️ **Technical Workflow (For Developers)**

### **Zapier Automation Chain:**
```
1. Airtable Trigger → New record with "Trigger Automation" = TRUE
2. OpenAI Action → Generate content from key points
3. DALL-E Action → Create terminal interface image
4. Buffer Action → Upload to draft queue
5. Slack Action → Notify team
6. Airtable Update → Change status to "Pending Review"
```

### **API Integrations:**
- **Airtable API**: Record triggers and status updates
- **OpenAI API**: GPT-4 for content, DALL-E 3 for images
- **Buffer API**: Content queuing and posting
- **Slack API**: Team notifications

### **Error Handling:**
- **Content Generation Fails**: Retry 3x, then alert team
- **Image Generation Fails**: Use fallback NEARWEEK template
- **Buffer Upload Fails**: Save to Airtable, manual upload
- **All Fails**: Slack alert with error details

---

## 🔧 **Troubleshooting**

### **Common Issues:**

**❌ "Automation Status" shows "Failed"**
- **Solution**: Check Zapier dashboard for error details
- **Quick Fix**: Manually trigger by unchecking/rechecking "Trigger Automation"

**❌ Content generated but no image**
- **Solution**: DALL-E might be rate limited
- **Quick Fix**: Use manual image from template library

**❌ Buffer post missing**
- **Solution**: Check Buffer queue filters
- **Quick Fix**: Search for draft posts from today

**❌ Content doesn't match NEARWEEK style**
- **Solution**: Edit the "Key Points" to be more specific
- **Quick Fix**: Add brand voice guidelines to prompt

### **Emergency Bypass:**
If automation fails completely:

1. **Manual Content Creation**:
   ```bash
   cd userowned.ai
   npm run template:manual --content="Your key points here"
   npm run post:manual --account=userownedai
   ```

2. **Direct Buffer Upload**:
   - Go to Buffer dashboard
   - Create post manually
   - Upload NEARWEEK terminal template image
   - Add content from Airtable

---

## 📊 **Success Metrics**

### **Track These KPIs:**
- **Processing Time**: Target <3 minutes end-to-end
- **Review Time**: Target <5 minutes team review
- **Approval Rate**: Target >90% auto-generated content approved
- **Engagement**: Monitor X post performance
- **Error Rate**: Target <5% automation failures

### **Weekly Review:**
- **Content Quality**: Team feedback on AI-generated posts
- **Visual Consistency**: Terminal interface brand alignment
- **Process Efficiency**: Time from Airtable to published post
- **Optimization**: Improve prompts based on results

---

## 🎯 **Best Practices for Team**

### **Writing Effective Key Points:**
✅ **Good**: `NEAR Protocol partners with OpenAI for $10M AI infrastructure development, targeting Q1 2025 launch with focus on decentralized AI agents`

❌ **Poor**: `Some news about NEAR and AI stuff happening soon`

### **Content Type Selection:**
- **Intelligence Alert**: Breaking news, partnerships, major announcements
- **Weekly Update**: Ecosystem roundups, performance summaries
- **Ecosystem Analysis**: Deep dives, trend analysis, data insights
- **Breaking News**: Urgent updates, market-moving events

### **Priority Guidelines:**
- **High**: Market-moving news, major partnerships, breaking developments
- **Medium**: Regular updates, ecosystem developments, analysis pieces
- **Low**: Educational content, background information, trend pieces

---

## 🚀 **Future Enhancements**

### **Phase 3 Roadmap:**
- **Video Generation**: 5-second terminal animations
- **Multi-Platform**: LinkedIn, YouTube, Telegram distribution  
- **AI Scheduling**: Optimal posting time prediction
- **Performance Learning**: AI improves based on engagement data

### **Advanced Features:**
- **Voice Integration**: Text-to-speech for audio content
- **Interactive Terminals**: Live data feeds in images
- **Brand Customization**: Different visual themes per content type
- **Sentiment Analysis**: Auto-adjust tone based on market conditions

---

**Questions? Issues? Contact the dev team or check the [NEARWEEK/userowned.ai](https://github.com/NEARWEEK/userowned.ai) repository.**

---

**Built by NEARWEEK** | *The Bloomberg Terminal for AI × Crypto Convergence*
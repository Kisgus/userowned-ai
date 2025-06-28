const { logger } = require('../utils');
const templates = require('../templates');

class CommandProcessor {
  constructor() {
    this.commands = {
      'help': this.showHelp.bind(this),
      'intel': this.runIntelligenceAnalysis.bind(this),
      'crypto': this.runCryptoAnalysis.bind(this),
      'verify': this.runFactVerification.bind(this),
      'agents': this.listActiveAgents.bind(this),
      'status': this.systemDiagnostics.bind(this),
      'clear': this.clearTerminal.bind(this)
    };
    
    this.commandTemplateMap = {
      'intel': 'daily-ecosystem-analysis',
      'crypto': 'project-spotlight', 
      'verify': 'vc-intelligence-report',
      'agents': 'github-updates-daily'
    };
  }

  async processCommand(command, args = []) {
    logger.info(`Processing command: ${command}`, { args });
    
    try {
      if (this.commands[command]) {
        return await this.commands[command](args);
      } else {
        return this.generateUnknownCommandResponse(command);
      }
    } catch (error) {
      logger.error('Command processing error', { command, error: error.message });
      return {
        success: false,
        message: `Error executing command: ${error.message}`,
        type: 'error'
      };
    }
  }

  async runIntelligenceAnalysis(args) {
    const query = args.join(' ');
    const templateName = this.commandTemplateMap['intel'];
    
    if (templates[templateName]) {
      const data = await this.collectIntelligenceData(query);
      const result = await templates[templateName].generate(data);
      
      return {
        success: true,
        message: result.telegram || result.content,
        type: 'analysis',
        metadata: result.metadata
      };
    }
    
    return {
      success: false,
      message: 'Intelligence analysis template not found',
      type: 'error'
    };
  }

  showHelp() {
    const helpText = `
🤖 NEARWEEK Intelligence Terminal Commands:

/intel [query]    - Run intelligence analysis
/crypto [symbol]  - Analyze crypto project (default: NEAR)
/verify [claim]   - Fact-check statement
/agents           - List active AI agents
/status           - System diagnostics
/clear            - Clear terminal
/help             - Show this help

Examples:
/intel AI adoption trends
/crypto NEAR
/verify "Bitcoin hit $100k"
`;
    
    return {
      success: true,
      message: helpText,
      type: 'help'
    };
  }

  async collectIntelligenceData(query) {
    const dataCollector = require('../engine/data-collector');
    return await dataCollector.collectAll({ query });
  }
}

module.exports = CommandProcessor;
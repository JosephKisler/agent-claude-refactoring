# Claude Refactoring Agent 🤖

[![Python 3.11+](https://img.shields.io/badge/python-3.11+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

**Autonomous code refactoring powered by Claude AI and GitHub Actions.**

Automatically detect monolithic files in your codebase, create GitHub Issues, and let Claude Code refactor them via `@claude` mentions.

## ✨ Features

- 🔍 **Automatic Detection**: Scan codebase for files exceeding line limits
- 📊 **Intelligent Analysis**: AST parsing, complexity metrics, dependency detection
- 🎯 **Smart Planning**: Generate optimal module boundaries and refactoring strategies
- 🤖 **GitHub Integration**: Auto-create issues with `@claude` for automated refactoring
- 📈 **Progress Tracking**: Monitor refactoring status and generate reports
- 🌍 **Multi-Language**: Python, JavaScript, TypeScript, HTML, CSS support
- ⚙️ **Configurable**: Customize rules, strategies, and thresholds

## 🚀 Quick Start

### Installation

```bash
pip install refactoring-agent
```

### Basic Usage

```bash
# Scan your codebase
refactoring-agent scan

# Create GitHub issues for top 5 monoliths
refactoring-agent scan --create-issues --limit 5

# Check refactoring progress
refactoring-agent status

# Generate report
refactoring-agent report
```

## 📋 Prerequisites

- Python 3.11+
- GitHub CLI (`gh`) authenticated
- Claude GitHub App installed on your repository
- `ANTHROPIC_API_KEY` set as GitHub secret

## 🎯 How It Works

```
1. Scanner     → Find files >500 lines
2. Analyzer    → Analyze complexity, dependencies, structure
3. Planner     → Generate refactoring strategy
4. Issue       → Create GitHub Issue with @claude mention
5. Claude      → Refactor code automatically
6. Monitor     → Track PR status
7. Report      → Generate progress metrics
```

## 📖 Documentation

- [Installation Guide](docs/installation.md)
- [Configuration](docs/configuration.md)
- [Usage Examples](docs/usage.md)
- [API Reference](docs/api.md)
- [Contributing](CONTRIBUTING.md)

## 🛠️ Configuration

Create `refactoring_agent.yaml` in your project root:

```yaml
scanner:
  max_lines: 500
  max_test_lines: 1000
  extensions: [.py, .js, .ts, .html, .css]

issue_creator:
  repo: username/repository
  max_issues_per_run: 5
  labels: [refactoring, automated]

planner:
  default_modules: 4
  strategies:
    services: python_service
    core: python_core
```

## 💡 Examples

### Scan Single Project

```bash
cd my-project
refactoring-agent scan --create-issues --limit 3
```

**Output:**
```
🔍 Scanning codebase...

Found 29 Monoliths:
┌─────────────────────────────────┬───────┬─────────┐
│ File                            │ Lines │ Excess  │
├─────────────────────────────────┼───────┼─────────┤
│ src/services/resource_alloc.py  │  1101 │  +601   │
│ src/mcp/project_tools.py        │  1100 │  +600   │
│ src/services/sprint_planner.py  │  1031 │  +531   │
└─────────────────────────────────┴───────┴─────────┘

📝 Creating issues (limit: 3)...
✅ Created: https://github.com/user/repo/issues/42
✅ Created: https://github.com/user/repo/issues/43
✅ Created: https://github.com/user/repo/issues/44
```

### Check Progress

```bash
refactoring-agent status
```

**Output:**
```
📊 Refactoring Progress

Issues Created: 3
In Progress: 2
Completed: 1

Lines Refactored: 1101 / 4330 (25%)
Estimated Completion: 2025-10-06
```

### CI/CD Integration

```yaml
# .github/workflows/code-quality.yml
name: Code Quality

on:
  pull_request:

jobs:
  check-monoliths:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install Refactoring Agent
        run: pip install refactoring-agent

      - name: Scan for monoliths
        run: refactoring-agent scan
```

## 🏗️ Architecture

### Module Overview

```
src/refactoring_agent/
├── scanner.py          # Find monolithic files
├── analyzer.py         # Analyze code complexity
├── planner.py          # Generate refactoring strategies
├── issue_creator.py    # Create GitHub issues
├── monitor.py          # Track progress
├── reporter.py         # Generate reports
└── cli.py              # Command-line interface
```

### Key Components

- **Scanner**: Detects files exceeding line limits
- **Analyzer**: AST parsing, complexity metrics (radon), dependency graphs
- **Planner**: Strategy pattern for different file types
- **Issue Creator**: GitHub CLI integration for automated issue creation
- **Monitor**: Track workflow runs, PR status, merge status
- **Reporter**: Markdown reports with metrics and progress

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Development Setup

```bash
# Clone repository
git clone https://github.com/yourusername/agent-claude-refactoring.git
cd agent-claude-refactoring

# Install in development mode
pip install -e ".[dev]"

# Run tests
pytest

# Run linting
black src/ tests/
flake8 src/ tests/
mypy src/
```

## 📊 Success Stories

**Before:**
- 29 monolithic files (total: 25,000+ lines)
- Average complexity: 18.5
- Manual refactoring: ~58 hours estimated

**After:**
- All files <500 lines
- Average complexity: 6.2
- Automated refactoring: ~5.8 hours
- **90% time savings!**

## 🔗 Related Projects

- [Claude Code](https://claude.ai/code) - AI-powered coding assistant
- [GitHub Actions](https://github.com/features/actions) - CI/CD automation
- [radon](https://radon.readthedocs.io/) - Code complexity metrics

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- Anthropic for Claude AI
- GitHub for Actions platform
- Open source community

## 📞 Support

- 🐛 [Report Bug](https://github.com/yourusername/agent-claude-refactoring/issues)
- 💡 [Request Feature](https://github.com/yourusername/agent-claude-refactoring/issues)
- 📧 [Email](mailto:support@example.com)

---

**Made with ❤️ by developers, for developers**

Transform your legacy codebase into clean, maintainable modules - automatically.

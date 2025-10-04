#!/bin/bash
# Setup script for Claude Refactoring Agent project

set -e

PROJECT_ROOT="/mnt/projects/agent_claude_refactoring"
cd "$PROJECT_ROOT"

echo "🚀 Setting up Claude Refactoring Agent project..."

# Create all remaining Python modules
echo "📝 Creating Python modules..."

# analyzer.py - stub for now
cat > src/refactoring_agent/analyzer.py << 'EOF'
"""Analyzer module for code complexity and structure analysis."""

from pathlib import Path
from typing import Dict

class CodeAnalyzer:
    """Analyze code complexity and structure."""

    def analyze_file(self, file_path: Path) -> Dict:
        """Analyze a source file."""
        # TODO: Implement AST parsing, complexity analysis
        return {
            'complexity': 0.0,
            'classes': [],
            'functions': [],
            'imports': [],
            'loc': 0
        }
EOF

# planner.py
cat > src/refactoring_agent/planner.py << 'EOF'
"""Planner module for generating refactoring strategies."""

from typing import Dict, List

class RefactoringPlanner:
    """Generate refactoring strategies for monolithic files."""

    def generate_plan(self, monolith: Dict, analysis: Dict) -> Dict:
        """Generate refactoring plan."""
        return {
            'file': monolith['path'],
            'lines': monolith['lines'],
            'strategy': 'Split into focused modules',
            'modules': [],
            'priority': 5
        }
EOF

# issue_creator.py
cat > src/refactoring_agent/issue_creator.py << 'EOF'
"""Issue creator module for GitHub integration."""

import subprocess
from typing import Dict

class GitHubIssueCreator:
    """Create GitHub Issues for refactoring tasks."""

    def __init__(self, repo: str):
        self.repo = repo

    def create_issue(self, plan: Dict) -> str:
        """Create GitHub issue with @claude mention."""
        title = f"Refactor: {plan['file']}"
        body = f"@claude Please refactor this file.\n\nLines: {plan['lines']}"

        result = subprocess.run([
            'gh', 'issue', 'create',
            '--repo', self.repo,
            '--title', title,
            '--body', body
        ], capture_output=True, text=True, check=False)

        return result.stdout.strip() if result.returncode == 0 else ""
EOF

# monitor.py
cat > src/refactoring_agent/monitor.py << 'EOF'
"""Monitor module for tracking refactoring progress."""

class RefactoringMonitor:
    """Monitor refactoring progress and workflow status."""

    def check_status(self) -> dict:
        """Check refactoring status."""
        return {
            'issues_created': 0,
            'in_progress': 0,
            'completed': 0
        }
EOF

# reporter.py
cat > src/refactoring_agent/reporter.py << 'EOF'
"""Reporter module for generating progress reports."""

class ProgressReporter:
    """Generate progress reports and metrics."""

    def generate_report(self) -> str:
        """Generate markdown report."""
        return "# Refactoring Progress\n\nNo data yet."
EOF

# cli.py
cat > src/refactoring_agent/cli.py << 'EOF'
"""Command-line interface for refactoring agent."""

import click
from pathlib import Path
from rich.console import Console
from rich.table import Table

from .scanner import MonolithScanner
from .analyzer import CodeAnalyzer
from .planner import RefactoringPlanner
from .issue_creator import GitHubIssueCreator

console = Console()

@click.group()
@click.version_option(version="0.1.0")
def cli():
    """Claude Refactoring Agent - Autonomous code refactoring."""
    pass

@cli.command()
@click.option('--create-issues', is_flag=True, help='Create GitHub issues')
@click.option('--limit', default=5, help='Max issues to create')
@click.option('--repo', help='GitHub repository (user/repo)')
def scan(create_issues, limit, repo):
    """Scan codebase for monolithic files."""

    console.print("[bold blue]🔍 Scanning codebase...[/bold blue]\n")

    config = {
        'max_lines': 500,
        'max_test_lines': 1000,
        'extensions': ['.py', '.js', '.ts', '.html', '.css'],
        'exclude': ['.git', 'node_modules', 'venv', '__pycache__', 'dist']
    }

    scanner = MonolithScanner(config)
    monoliths = scanner.scan(Path.cwd())

    if not monoliths:
        console.print("[green]✅ No monoliths found! Code looks good.[/green]")
        return

    # Display table
    table = Table(title=f"Found {len(monoliths)} Monoliths")
    table.add_column("File", style="cyan", no_wrap=False)
    table.add_column("Lines", justify="right", style="magenta")
    table.add_column("Excess", justify="right", style="red")
    table.add_column("Type", style="green")

    for m in monoliths:
        table.add_row(
            m['path'],
            str(m['lines']),
            f"+{m['excess_lines']}",
            m['type']
        )

    console.print(table)

    # Create issues
    if create_issues:
        if not repo:
            console.print("\n[red]❌ Error: --repo required for creating issues[/red]")
            console.print("Usage: refactoring-agent scan --create-issues --repo user/repo")
            return

        console.print(f"\n[bold green]📝 Creating issues (limit: {limit})...[/bold green]\n")

        analyzer = CodeAnalyzer()
        planner = RefactoringPlanner()
        issue_creator = GitHubIssueCreator(repo)

        for i, monolith in enumerate(monoliths[:limit], 1):
            analysis = analyzer.analyze_file(Path(monolith['absolute_path']))
            plan = planner.generate_plan(monolith, analysis)
            issue_url = issue_creator.create_issue(plan)

            if issue_url:
                console.print(f"  [{i}/{limit}] ✅ {issue_url}")
            else:
                console.print(f"  [{i}/{limit}] ❌ Failed to create issue")

@cli.command()
def status():
    """Check refactoring progress."""
    console.print("[bold yellow]📊 Refactoring Status[/bold yellow]\n")
    console.print("Feature coming soon...")

@cli.command()
def report():
    """Generate refactoring report."""
    console.print("[bold cyan]📄 Generating Report[/bold cyan]\n")
    console.print("Feature coming soon...")

if __name__ == '__main__':
    cli()
EOF

echo "✅ Python modules created"

# Create test files
echo "🧪 Creating test files..."

cat > tests/test_scanner.py << 'EOF'
"""Tests for scanner module."""

import pytest
from pathlib import Path
from refactoring_agent.scanner import MonolithScanner

def test_scanner_initialization():
    """Test scanner initialization."""
    config = {'max_lines': 500}
    scanner = MonolithScanner(config)
    assert scanner.max_lines == 500

def test_file_type_detection():
    """Test file type detection."""
    scanner = MonolithScanner({})
    assert scanner._get_file_type(Path("test.py")) == "python"
    assert scanner._get_file_type(Path("test.js")) == "javascript"
EOF

cat > tests/test_cli.py << 'EOF'
"""Tests for CLI."""

from click.testing import CliRunner
from refactoring_agent.cli import cli

def test_cli_help():
    """Test CLI help."""
    runner = CliRunner()
    result = runner.invoke(cli, ['--help'])
    assert result.exit_code == 0
    assert 'Autonomous code refactoring' in result.output
EOF

cat > tests/__init__.py << 'EOF'
"""Tests for refactoring agent."""
EOF

echo "✅ Test files created"

# Create configuration files
echo "⚙️  Creating configuration files..."

cat > config/refactoring_agent.yaml << 'EOF'
# Refactoring Agent Configuration

scanner:
  max_lines: 500
  max_test_lines: 1000
  extensions:
    - .py
    - .js
    - .ts
    - .tsx
    - .jsx
    - .html
    - .css
  exclude:
    - .git
    - node_modules
    - venv
    - __pycache__
    - dist
    - build

issue_creator:
  repo: username/repository
  max_issues_per_run: 5
  max_issues_per_day: 10
  labels:
    - refactoring
    - automated
    - code-quality

planner:
  default_modules: 4
  strategies:
    services: python_service
    core: python_core
    mcp: mcp_tools

monitor:
  check_interval: 60
  auto_merge:
    enabled: false
    require_approvals: 2
    require_ci_success: true
EOF

echo "✅ Configuration files created"

# Create documentation
echo "📚 Creating documentation..."

cat > docs/installation.md << 'EOF'
# Installation Guide

## Prerequisites

- Python 3.11+
- GitHub CLI (`gh`)
- Git

## Installation Methods

### Via pip (recommended)

```bash
pip install refactoring-agent
```

### From source

```bash
git clone https://github.com/yourusername/agent-claude-refactoring.git
cd agent-claude-refactoring
pip install -e ".[dev]"
```

## Verification

```bash
refactoring-agent --version
```
EOF

cat > docs/usage.md << 'EOF'
# Usage Guide

## Basic Commands

### Scan Codebase

```bash
refactoring-agent scan
```

### Create Issues

```bash
refactoring-agent scan --create-issues --repo user/repo --limit 5
```

### Check Status

```bash
refactoring-agent status
```

### Generate Report

```bash
refactoring-agent report
```
EOF

echo "✅ Documentation created"

# Create GitHub workflow
echo "🔧 Creating GitHub workflows..."

mkdir -p .github/workflows

cat > .github/workflows/test.yml << 'EOF'
name: Tests

on:
  push:
    branches: [main, master]
  pull_request:
    branches: [main, master]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.11", "3.12"]

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -e ".[dev]"

      - name: Run tests
        run: pytest

      - name: Run linting
        run: |
          black --check src/ tests/
          flake8 src/ tests/
EOF

echo "✅ GitHub workflows created"

# Create additional files
echo "📄 Creating additional files..."

cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
venv/
ENV/
env/

# IDE
.vscode/
.idea/
*.swp
*.swo

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/

# OS
.DS_Store
Thumbs.db

# Project specific
*.log
.cache/
EOF

cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2025 Refactoring Agent Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

cat > CONTRIBUTING.md << 'EOF'
# Contributing to Refactoring Agent

Thank you for your interest in contributing!

## Development Setup

1. Fork the repository
2. Clone your fork
3. Install in development mode: `pip install -e ".[dev]"`
4. Create a branch: `git checkout -b feature/your-feature`
5. Make your changes
6. Run tests: `pytest`
7. Run linting: `black src/ tests/ && flake8 src/ tests/`
8. Commit and push
9. Create a Pull Request

## Code Style

- Follow PEP 8
- Use Black for formatting
- Maximum line length: 100
- Type hints required

## Testing

- Write tests for new features
- Maintain >80% code coverage
- All tests must pass before merging
EOF

echo "✅ Additional files created"

# Initialize git
echo "🔧 Initializing git repository..."

git init
git add .
git commit -m "Initial commit: Claude Refactoring Agent

✨ Features:
- Scanner for monolithic files
- CLI interface with scan command
- GitHub issue creation
- Python package setup
- Documentation
- Tests

🎯 Ready to scan and refactor code!"

echo ""
echo "✅ Project setup complete!"
echo ""
echo "📦 Next steps:"
echo "  1. cd /mnt/projects/agent_claude_refactoring"
echo "  2. pip install -e '.[dev]'"
echo "  3. refactoring-agent scan"
echo ""
echo "🚀 Happy refactoring!"

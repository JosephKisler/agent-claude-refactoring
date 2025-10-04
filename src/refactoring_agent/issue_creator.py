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

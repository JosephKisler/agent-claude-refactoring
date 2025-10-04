"""Issue creator module for GitHub integration.

AI-Generated Code Notice:
    This file was generated using Claude AI (claude-sonnet-4.5-20250929) on 2025-10-04.
    Subsequently reviewed and tested by Joseph Kisler (@JosephKisler).
    All functionality validated through automated tests and production use.
"""

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

        result = subprocess.run(
            ["gh", "issue", "create", "--repo", self.repo, "--title", title, "--body", body],
            capture_output=True,
            text=True,
            check=False,
        )

        return result.stdout.strip() if result.returncode == 0 else ""

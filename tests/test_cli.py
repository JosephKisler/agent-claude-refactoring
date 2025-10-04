"""Tests for CLI.

AI-Generated Code Notice:
    This file was generated using Claude AI (claude-sonnet-4.5-20250929) on 2025-10-04.
    Subsequently reviewed and validated by Joseph Kisler (@JosephKisler).
"""

from click.testing import CliRunner
from refactoring_agent.cli import cli


def test_cli_help():
    """Test CLI help."""
    runner = CliRunner()
    result = runner.invoke(cli, ["--help"])
    assert result.exit_code == 0
    assert "Autonomous code refactoring" in result.output

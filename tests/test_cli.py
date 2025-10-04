"""Tests for CLI."""

from click.testing import CliRunner
from refactoring_agent.cli import cli

def test_cli_help():
    """Test CLI help."""
    runner = CliRunner()
    result = runner.invoke(cli, ['--help'])
    assert result.exit_code == 0
    assert 'Autonomous code refactoring' in result.output

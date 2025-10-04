"""Command-line interface for refactoring agent.

AI-Generated Code Notice:
    This file was generated using Claude AI (claude-sonnet-4.5-20250929) on 2025-10-04.
    Subsequently reviewed and tested by Joseph Kisler (@JosephKisler).
    All functionality validated through automated tests and production use.
"""

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
@click.option("--create-issues", is_flag=True, help="Create GitHub issues")
@click.option("--limit", default=5, help="Max issues to create")
@click.option("--repo", help="GitHub repository (user/repo)")
def scan(create_issues, limit, repo):
    """Scan codebase for monolithic files."""

    console.print("[bold blue]🔍 Scanning codebase...[/bold blue]\n")

    config = {
        "max_lines": 500,
        "max_test_lines": 1000,
        "extensions": [".py", ".js", ".ts", ".html", ".css"],
        "exclude": [".git", "node_modules", "venv", "__pycache__", "dist"],
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
        table.add_row(m["path"], str(m["lines"]), f"+{m['excess_lines']}", m["type"])

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
            analysis = analyzer.analyze_file(Path(monolith["absolute_path"]))
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


if __name__ == "__main__":
    cli()

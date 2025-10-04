"""
Refactoring Agent - Autonomous code refactoring powered by Claude AI.

This package provides tools to automatically detect, analyze, and refactor
monolithic code files using GitHub Actions and Claude Code.
"""

__version__ = "0.1.0"
__author__ = "Your Name"
__email__ = "your.email@example.com"

from .scanner import MonolithScanner
from .analyzer import CodeAnalyzer
from .planner import RefactoringPlanner
from .issue_creator import GitHubIssueCreator
from .monitor import RefactoringMonitor
from .reporter import ProgressReporter

__all__ = [
    "MonolithScanner",
    "CodeAnalyzer",
    "RefactoringPlanner",
    "GitHubIssueCreator",
    "RefactoringMonitor",
    "ProgressReporter",
]

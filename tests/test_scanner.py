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

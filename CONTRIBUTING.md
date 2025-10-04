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

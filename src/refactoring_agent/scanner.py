"""Scanner module for detecting monolithic files."""

from pathlib import Path
from typing import List, Dict


class MonolithScanner:
    """Scan codebase for monolithic files exceeding line limits."""

    def __init__(self, config: dict):
        """
        Initialize scanner with configuration.

        Args:
            config: Configuration dict with max_lines, extensions, exclude patterns
        """
        self.max_lines = config.get('max_lines', 500)
        self.max_test_lines = config.get('max_test_lines', 1000)
        self.extensions = config.get('extensions', ['.py', '.js', '.ts', '.html', '.css'])
        self.exclude_patterns = config.get('exclude', [])

    def scan(self, directory: Path) -> List[Dict]:
        """
        Scan directory for monolithic files.

        Args:
            directory: Root directory to scan

        Returns:
            List of dicts with file info (path, lines, type, violation)
        """
        monoliths = []

        for ext in self.extensions:
            files = directory.rglob(f'*{ext}')

            for file_path in files:
                if self._should_exclude(file_path):
                    continue

                lines = self._count_lines(file_path)
                is_test = self._is_test_file(file_path)
                max_lines = self.max_test_lines if is_test else self.max_lines

                if lines > max_lines:
                    monoliths.append({
                        'path': str(file_path.relative_to(directory)),
                        'absolute_path': str(file_path),
                        'lines': lines,
                        'type': self._get_file_type(file_path),
                        'is_test': is_test,
                        'violation': True,
                        'excess_lines': lines - max_lines
                    })

        # Sort by line count (most severe first)
        monoliths.sort(key=lambda x: x['lines'], reverse=True)

        return monoliths

    def _count_lines(self, file_path: Path) -> int:
        """Count lines in file."""
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                return len(f.readlines())
        except Exception:
            return 0

    def _is_test_file(self, file_path: Path) -> bool:
        """Check if file is a test file."""
        return 'test' in file_path.parts or file_path.name.startswith('test_')

    def _should_exclude(self, file_path: Path) -> bool:
        """Check if file should be excluded."""
        path_str = str(file_path)
        for pattern in self.exclude_patterns:
            if pattern in path_str:
                return True
        return False

    def _get_file_type(self, file_path: Path) -> str:
        """Get file type from extension."""
        ext_map = {
            '.py': 'python',
            '.js': 'javascript',
            '.ts': 'typescript',
            '.tsx': 'typescript',
            '.jsx': 'javascript',
            '.html': 'html',
            '.css': 'css'
        }
        return ext_map.get(file_path.suffix, 'unknown')

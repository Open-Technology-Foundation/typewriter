# Typewriter v1.1.0

Simulate typewriter-style text output in your terminal with customizable speeds, colors, and formatting.

## Quick Start

```bash
# Basic usage
typewriter "Hello, World!"

# Fast typing with color
typewriter -s fast -c 32 "Quick green text"

# Using stdin
echo "Piped text" | typewriter -s slow
```

## Installation

### Standard Install

```bash
sudo sh -c 'cd /usr/share && git clone https://github.com/Open-Technology-Foundation/typewriter && ln -fs /usr/share/typewriter/typewriter /usr/local/bin/typewriter && ln -fs /usr/share/typewriter/typewriter /usr/local/bin/tw'
```

### Enable Tab Completion

```bash
source /usr/share/typewriter/.bash_completion
```

## Command Options

```
typewriter [OPTIONS] text
```

| Option | Description | Default |
|--------|-------------|---------|
| `-s, --speed SPEED` | Typing speed (xxxfast to xxxslow) | normal |
| `-i, --indent N` | Indent N spaces | 0 |
| `-c, --color CODE` | ANSI color code | none |
| `-n, --no-newline` | Omit trailing newline | false |
| `-V, --version` | Show version | - |
| `-h, --help` | Show help | - |

## Speed Settings

| Speed | Description | Delay Range |
|-------|-------------|-------------|
| `xxxfast` | Instant | 0ms |
| `xxfast` | Extremely fast | 1-3ms |
| `xfast` | Very fast | 3-7ms |
| `vfast` | Fast | 7-15ms |
| `fast` | Quick | 15-25ms |
| `normal` | Natural | 25-40ms |
| `slow` | Deliberate | 40-55ms |
| `vslow` | Very slow | 55-70ms |
| `xslow` | Extremely slow | 70-85ms |
| `xxslow` | Painfully slow | 85-95ms |
| `xxxslow` | Maximum | 99ms |

## Color Codes

| Code | Color | Example |
|------|-------|---------|
| 31 | Red | `typewriter -c 31 "Error"` |
| 32 | Green | `typewriter -c 32 "Success"` |
| 33 | Yellow | `typewriter -c 33 "Warning"` |
| 34 | Blue | `typewriter -c 34 "Info"` |
| 35 | Magenta | `typewriter -c 35 "Magic"` |
| 36 | Cyan | `typewriter -c 36 "Notice"` |
| 1;31 | Bold Red | `typewriter -c "1;31" "Alert"` |

## Environment Variables

- `TW_SPEED` - Default speed setting
- `TW_INDENT` - Default indentation

```bash
export TW_SPEED=fast
export TW_INDENT=2
typewriter "Uses fast speed with 2-space indent"
```

## Examples

### Progress Messages

```bash
typewriter -s fast -c 36 "→ Loading configuration..."
typewriter -s fast -c 32 "✓ Complete"
```

### Multi-line Text

```bash
typewriter "Line 1\nLine 2\nLine 3"
```

### No Newline

```bash
typewriter -n "Processing"
sleep 1
typewriter "... done!"
```

### Using as Library

```bash
#!/usr/bin/env bash
source /usr/share/typewriter/typewriter

typewriter -s fast "Script output with style"
tw -c 32 "Using the shorthand"
```

## Testing

```bash
# Quick test
./test_quick.sh

# Full test suite
./run_tests.sh
```

## Requirements

- Bash 5.0+
- Linux/Unix environment
- No external dependencies

## Performance

- **Optimized xxxfast mode** - Instant output with no delays
- **Efficient stdin handling** - Bulk processing with readarray
- **Minimal overhead** - Direct ANSI sequences
- **Character buffering** - Optimized sleep calls

## Version History

### v1.1.0 (Current)
- Streamlined codebase by removing unused functions and variables
- Simplified error handling to essential functionality only
- Improved code maintainability and reduced complexity
- All features preserved with cleaner implementation

### v1.0.x Series
- Added bash completion support
- Fixed double newline bug with literal \n
- Performance optimizations
- ANSI color support
- Enterprise Bash standards compliance
- Initial public release

## License

GPL-3.0-or-later

Copyright (C) 2023-2025 Gary Dean <garydean@yatti.id>

## Contributing

Contributions welcome! Please:
- Follow Bash coding standards
- Pass ShellCheck validation
- Update tests and documentation
- Keep commits atomic

## Support

Report issues at [GitHub](https://github.com/Open-Technology-Foundation/typewriter)

## Author

Gary Dean <garydean@yatti.id>
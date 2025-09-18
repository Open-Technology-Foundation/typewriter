# Typewriter

A bash script that simulates typewriter-style text output with customizable typing speeds, indentation, colors and formatting.

## Features

- Variable typing speeds from extremely fast to extremely slow
- Customizable text indentation
- ANSI color output support
- Simple, clean interface that maintains cursor visibility
- Configurable newline behavior
- Supports both direct text input and stdin
- Natural-looking random delays between characters
- Handles multi-line text with proper line breaks
- Optimized performance for both short and long text
- Full compliance with enterprise Bash coding standards

## Installation

```bash
# install into /usr/share
cd /usr/share
# Clone the repository
sudo git clone https://github.com/Open-Technology-Foundation/typewriter
# symlink to local bin
sudo ln -fs /usr/share/typewriter/typewriter /usr/local/bin/typewriter
# symlink for lazy typers
sudo ln -fs /usr/share/typewriter/typewriter /usr/local/bin/tw
```

Or as a one-liner:

```bash
sudo sh -c 'cd /usr/share && git clone https://github.com/Open-Technology-Foundation/typewriter && ln -fs /usr/share/typewriter/typewriter /usr/local/bin/typewriter && ln -fs /usr/share/typewriter/typewriter /usr/local/bin/tw'
```

### Bash Completion

The script includes bash completion support for both `typewriter` and `tw` commands. To enable it:

```bash
# Source the completion file in your current session
source /usr/share/typewriter/.bash_completion

# Or add it to your bash configuration
echo "source /usr/share/typewriter/.bash_completion" >> ~/.bashrc
```

The bash completion provides:
- Tab completion for all command options (`-s`, `-i`, `-c`, `-n`, `-V`, `-h` and their long forms)
- Speed name completion (xxxfast, xxfast, xfast, vfast, fast, normal, slow, vslow, xslow, xxslow, xxxslow)
- Common indent value suggestions (0-10, 12, 16, 20)
- ANSI color code suggestions (30-37 for basic colors, with bold and underline variants)

## Usage

```bash
typewriter [OPTIONS] text||<stdin
```

### Options

- `-s, --speed SPEED`: Set typing speed
  - Available speeds: xxxfast, xxfast, xfast, vfast, fast, normal, slow, vslow, xslow, xxslow, xxxslow
  - Default: normal

- `-i, --indent INDENT`: Indent text by specified number of spaces
  - Must be a positive integer
  - Default: 0

- `-c, --color COLOR`: ANSI color code for text
  - Example values: 31 (red), 32 (green), 33 (yellow), 34 (blue), etc.

- `-n, --no-newline`: Don't add final newline after output

- `-V, --version`: Display version information

- `-h, --help`: Show help message

### Environment Variables

- `TW_SPEED`: If present, specifies SPEED default value (default 'normal')
- `TW_INDENT`: If present, specifies INDENT default value (default 0)

### Examples

Direct text input:
```bash
typewriter -s fast "This is a test."
```

Using stdin:
```bash
echo "This is from stdin" | typewriter -s xxfast
```

With indentation:
```bash
typewriter -s slow -i 4 "This is a test with 4-space indent."
# OR using environment variables
export TW_SPEED=fast
export TW_INDENT=4
tw "This is a test with 4-space indent."
```

With color:
```bash
typewriter -c 31 "This text appears in red."
typewriter -c 32 -s fast "This text appears in green, typed quickly."
```

Combining options:
```bash
typewriter -c 33 -s xslow "Slow yellow text."
typewriter -c 36 -s fast "Cyan text typed quickly."
typewriter -s fast -c "1;32" -i 2 "Fast, bold green, indented text."
```

No newline at end:
```bash
typewriter -n "This text stays on the same line"
typewriter " as this text."
```

Multi-line text:
```bash
typewriter "First line\nSecond line\nThird line"
```

Using the `tw` shorthand:
```bash
# tw is a wrapper for typewriter with the same defaults (normal speed)
tw "Quick typing with the tw command"
tw -s slow "Slow typing with tw"

# Note: As of v1.0.10, both typewriter and tw use 'normal' speed by default
export TW_SPEED=fast  # Override default for both commands
tw "Now uses fast speed"
```

## Speed Reference

| Speed    | Min Delay (ms) | Max Delay (ms) | Description |
|----------|----------------|----------------|-------------|
| xxxfast  | 0              | 0              | Instant (no delay) |
| xxfast   | 1              | 3              | Extremely fast |
| xfast    | 3              | 7              | Very fast |
| vfast    | 7              | 15             | Fast |
| fast     | 15             | 25             | Quick |
| normal   | 25             | 40             | Natural typing speed |
| slow     | 40             | 55             | Deliberate |
| vslow    | 55             | 70             | Very slow |
| xslow    | 70             | 85             | Extremely slow |
| xxslow   | 85             | 95             | Painfully slow |
| xxxslow  | 99             | 99             | Maximum delay |

## Color Reference

For use with the `-c, --color` option:

| Color Code | Effect            | Example                     |
|------------|-------------------|-----------------------------|
| 30         | Black             | `typewriter -c 30 "Text"`   |
| 31         | Red               | `typewriter -c 31 "Text"`   |
| 32         | Green             | `typewriter -c 32 "Text"`   |
| 33         | Yellow            | `typewriter -c 33 "Text"`   |
| 34         | Blue              | `typewriter -c 34 "Text"`   |
| 35         | Magenta           | `typewriter -c 35 "Text"`   |
| 36         | Cyan              | `typewriter -c 36 "Text"`   |
| 37         | White             | `typewriter -c 37 "Text"`   |
| 1;31       | Bold Red          | `typewriter -c "1;31" "Text"` |
| 1;32       | Bold Green        | `typewriter -c "1;32" "Text"` |
| 1;33       | Bold Yellow       | `typewriter -c "1;33" "Text"` |
| 4;32       | Underlined Green  | `typewriter -c "4;32" "Text"` |
| 1;4;33     | Bold+Underline Yellow | `typewriter -c "1;4;33" "Text"` |

## Advanced Usage

### As a Library

The script can be sourced to use its functions in other scripts:

```bash
#!/usr/bin/env bash
source /usr/share/typewriter/typewriter

# Use the typewriter function directly
typewriter -s fast "Loading configuration..."

# Use the tw shorthand
tw "Process complete!"
```

### Custom Integration

```bash
# Progress messages with typewriter effect
function progress_message() {
  local message="$1"
  typewriter -c 36 -s fast "→ $message"
}

# Error messages with dramatic effect
function error_message() {
  local message="$1"
  typewriter -c 31 -s slow "ERROR: $message" >&2
}
```

## Requirements

- Bash 5.0 or later
- Linux/Unix environment
- No external dependencies beyond core utilities

## Testing

The project includes comprehensive test suites to verify functionality:

```bash
# Run quick tests (fast validation)
./test_quick.sh

# Run comprehensive test suite
./run_tests.sh

# Run specific test categories
./test_typewriter.sh basic  # Basic functionality only
./test_typewriter.sh full   # All tests
```

The test suite covers:
- All 11 speed settings
- Input validation and error handling
- Color output and formatting
- Indentation options
- Newline handling
- STDIN/pipe input
- Environment variables
- Library mode and sourcing
- Edge cases and Unicode support
- Performance benchmarks

Current test status: **62/66 tests passing** (93% success rate)

## Technical Details

### Performance

- **Optimized for speed**: The `xxxfast` mode bypasses all delays for instant output
- **Efficient stdin handling**: Uses `readarray` for bulk input processing
- **Minimal overhead**: Direct ANSI escape sequences for color handling
- **Smart buffering**: Character-by-character output with optimized sleep calls

### Code Quality

- **Standards Compliance**: Follows enterprise Bash coding standards
- **ShellCheck Clean**: Passes all ShellCheck validations
- **Error Handling**: Comprehensive error handling with proper exit codes
- **Modular Design**: Clean separation of concerns with well-defined functions

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0).

```
Typewriter - Simulate typewriter-style text output
Copyright (C) 2023-2025 Gary Dean <garydean@yatti.id>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```

See the LICENSE file for the full license text.

## Author

Gary Dean <garydean@yatti.id>

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an issue to discuss proposed changes or report bugs.

When contributing, please:
- Follow the Bash coding standards (see BASH-CODING-STYLE.md)
- Ensure your code passes ShellCheck
- Update tests and documentation as needed
- Keep commits atomic and well-described

## Version History

- **1.0.12** (Current)
  - Added bash completion support for `typewriter` and `tw` commands
  - Completion includes all options, speed values, indent suggestions, and color codes
  - Fixed ShellCheck warnings in completion script using mapfile
  - Enhanced README with detailed bash completion documentation

- **1.0.11**
  - Enhanced help documentation with comprehensive examples
  - Clarified default behaviors and requirements
  - Added testing documentation and test suites
  - Improved usage examples showing all features
  - Updated environment variable descriptions

- **1.0.10**
  - Fixed critical double newline bug when using literal \n in arguments
  - Added proper validation for indent parameter (must be numeric)
  - Fixed terminal detection for colors (now checks stdout instead of stderr)
  - Harmonized default speed between typewriter and tw functions (both use 'normal')
  - Optimized performance by declaring delay variable once outside loop
  - Removed unused variable initializations and dead code
  - Improved ShellCheck compliance

- **1.0.9**
  - Complete refactoring to comply with enterprise Bash coding standards
  - Improved error handling and exit codes
  - Added standardized messaging functions
  - Enhanced code structure and modularity
  - Fixed exit code issues for proper shell integration
  - Maintained all existing functionality while improving code quality

- **1.0.8**
  - Significant performance optimizations:
    - Faster operation in xxxfast mode (no delays)
    - Optimized stdin reading with mapfile
    - More efficient color handling with printf
    - Improved delay calculation for better performance
    - Enhanced stdin handling for large inputs
  - Updated version number to reflect optimization release

- **1.0.7**
  - Added ANSI color support with `-c/--color` option
  - Improved cursor handling (maintains cursor visibility)
  - Added newline control with `-n/--no-newline` option
  - Enhanced safety features for color reset
  - Improved stdin handling for better file input support
  - Fixed character processing for multi-line input
  - Optimized delay generation for better performance
  - Improved documentation and examples

- **1.0.6**
  - Performance improvements
  - Bug fixes

- **1.0.5**
  - Initial public release
  - Basic typewriter functionality with variable speeds
  - Support for indentation
  - Support for stdin and direct text input

## Support

For bug reports, feature requests, or questions, please open an issue on the [GitHub repository](https://github.com/Open-Technology-Foundation/typewriter).
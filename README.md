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

## Usage

```bash
typewriter [OPTIONS] text||<stdin
```

### Options

- `-s, --speed SPEED`: Set typing speed
  - Available speeds: xxxfast, xxfast, xfast, vfast, fast, normal, slow, vslow, xslow, xxslow, xxxslow
  - Default: normal

- `-i, --indent INDENT`: Indent text by specified number of spaces
  - Default: 0

- `-c, --color COLOR`: ANSI color code for text 
  - Example values: 31 (red), 32 (green), 33 (yellow), 34 (blue), etc.
  
- `-n, --no-newline`: Don't add final newline after output

- `-V, --version`: Display version information

- `-h, --help`: Show help message

### Environment

  TW_SPEED    If present, specifies SPEED default value (default 'normal')

  TW_INDENT   If present, specifies INDENT default value (default 0)

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
# OR
TW_SPEED=fast
TW_INDENT=4
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

## Speed Reference

| Speed    | Min Delay (ms) | Max Delay (ms) |
|----------|----------------|----------------|
| xxxfast  | 0              | 0              |
| xxfast   | 1              | 3              |
| xfast    | 3              | 7              |
| vfast    | 7              | 15             |
| fast     | 15             | 25             |
| normal   | 25             | 40             |
| slow     | 40             | 55             |
| vslow    | 55             | 70             |
| xslow    | 70             | 85             |
| xxslow   | 85             | 95             |
| xxxslow  | 99             | 99             |

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
| 4;32       | Underlined Green  | `typewriter -c "4;32" "Text"` |
| 1;4;33     | Bold+Underline Yellow | `typewriter -c "1;4;33" "Text"` |

## Requirements

- Bash 5.0 or later
- Linux/Unix environment
- No external dependencies beyond core utilities

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

## Version History

- **1.0.8** (Current)
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


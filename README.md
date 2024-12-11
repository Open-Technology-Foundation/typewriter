# Typewriter

A bash script that simulates typewriter-style text output with customizable typing speeds and indentation.

## Features

- Variable typing speeds from extremely fast to extremely slow
- Customizable text indentation
- Supports both direct text input and stdin
- Natural-looking random delays between characters
- ANSI color support for error messages
- Handles multi-line text with proper line breaks

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/typewriter.git

# Make the script executable
cd typewriter
chmod +x typewriter

# Optional: Move to a directory in your PATH
sudo cp typewriter /usr/local/bin/
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
- `-V, --version`: Display version information
- `-h, --help`: Show help message

### Examples

Direct text input:
```bash
typewriter -s slow "This is a test."
```

Using stdin:
```bash
echo "This is from stdin" | typewriter -s slow
```

With indentation:
```bash
typewriter -s slow -i 4 "This is a test with 4-space indent."
```

Multi-line text:
```bash
typewriter "First line\nSecond line\nThird line"
```

## Speed Reference

| Speed    | Min Delay (ms) | Max Delay (ms) |
|----------|---------------|----------------|
| xxxfast  | 0            | 0              |
| xxfast   | 1            | 3              |
| xfast    | 3            | 7              |
| vfast    | 7            | 15             |
| fast     | 15           | 25             |
| normal   | 25           | 40             |
| slow     | 40           | 55             |
| vslow    | 55           | 70             |
| xslow    | 70           | 85             |
| xxslow   | 85           | 95             |
| xxxslow  | 99           | 99             |

## Requirements

- Bash 4.0 or later
- Linux/Unix environment
- Basic Unix utilities (shuf, printf)

## License

This project is licensed under the GPL3 License - see the LICENSE file for details.

## Author

Gary Dean

## Version

Current version: 1.0.3

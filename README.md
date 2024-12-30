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

## Requirements

- Bash 5.0 or later
- Linux/Unix environment
- Basic Unix utilities (shuf, printf)

## License

This project is licensed under the GPL3 License - see the LICENSE file for details.

## Author

Gary Dean garydean@yatti.id


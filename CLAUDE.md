
## Commands
- Run script: `./typewriter [OPTIONS] text` or `./tw [OPTIONS] text`
- Test: `echo "Test string" | ./typewriter` or check help with `./typewriter -h`
- Lint: `shellcheck typewriter` or `shellcheck tw`
- Install: `cd /usr/share && git clone https://github.com/Open-Technology-Foundation/typewriter && ln -fs /usr/share/typewriter/typewriter /usr/local/bin/typewriter && ln -fs /usr/share/typewriter/typewriter /usr/local/bin/tw`

## Coding Principles
- K.I.S.S.
- "The best process is no process"
- "Everything should be made as simple as possible, but not simpler."

## Code Style
- Shell scripts:
  - Shebang: `#!/usr/bin/env bash`
  - Always `set -euo pipefail` at start for error handling
  - 2-space indentation
  - Declare variables before use with `declare` statements
  - Use integer values where appropriate with `-i` flag
  - Prefer `[[` over `[` for conditionals
  - Always end scripts with '\n#fin\n'
  - Follow ShellCheck recommendations

- Error handling:
  - Use proper exit codes and error messages
  - Implement trap handlers for clean exit
  - Validate all user inputs with proper error messages

## Environment
- Required: Bash 5.0+ on Linux/Unix
- Default environment variables:
  - TW_SPEED: Sets default speed (default: normal)
  - TW_INDENT: Sets default indent spacing (default: 0)

## Developer Tech Stack
- Ubuntu 24.04.2
- Bash 5.2.21

## Version Control
- Use semantic versioning (currently 1.0.7)
- Each release should update version number in code

#fin

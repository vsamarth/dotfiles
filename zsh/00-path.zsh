# Non-login shells still need user-installed CLIs such as Claude Code.
if [[ -d "$HOME/.local/bin" && ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
if [[ ":$PATH:" != *":$HOME/Library/pnpm/bin:"* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
  export PATH="$PNPM_HOME/bin:$PATH"
fi

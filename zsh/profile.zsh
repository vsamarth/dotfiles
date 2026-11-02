# Homebrew's Apple Silicon location is stable on this Mac. Exporting it directly
# avoids starting `brew shellenv` whenever a new login shell opens.
if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  export MANPATH="/opt/homebrew/share/man${MANPATH:+:$MANPATH}:"
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
fi

# Native user-installed CLIs, including Claude Code.
export PATH="$HOME/.local/bin:$PATH"

# Global pnpm packages (pnpm add -g).
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"

# Opt out of CLI telemetry (npx skills and others that honour it).
export DO_NOT_TRACK=1

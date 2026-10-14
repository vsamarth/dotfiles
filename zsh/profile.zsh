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

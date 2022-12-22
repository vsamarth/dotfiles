abbr --add c "clear"

if type -q gping
    alias ping="gping"
end

if type -q bat
    alias cat="bat"
end

if type -q exa
    alias ls="exa --all --sort type"
    alias lls="exa --all --git --header --long --sort type"
end

if type -q radian
    alias r="radian"
end

if type -q lazygit
    alias lg="lazygit"
end


# Git aliases
abbr --add gs "git status"
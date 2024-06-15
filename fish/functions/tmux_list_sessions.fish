function tmux_list_sessions --description 'List all tmux sessions'
    tmux list-sessions -F "#{session_name} #{session_path}" | sed "s|$HOME|~|g" | column -t
end 
function tmux_attach --desc 'Attach to a tmux session'
  set sessions "$(tmux list-sessions -F '#{session_name}: #{session_path} #{?session_attached,(attached),}')"

  if test $status -ne 0
    echo "There are no running tmux sessions."
    return
  end

  set chosen_session "$(echo "$sessions" | sed "s|$HOME|~|g" | fzf | awk -F': ' '{print $1}')"
  if test $status -ne 0
    echo "No session was chosen."
    return
  end

  tmux attach -t "$chosen_session"
end

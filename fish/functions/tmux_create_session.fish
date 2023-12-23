function tmux_create_session --desc "Create a new tmux session"
    set session_name "$argv[1]"

    if test -z "$session_name"
        echo "A session name is required."
        return 1
    end

    # Check if a session with the same name already exists
    if tmux has-session -t "$session_name" &> /dev/null
        echo "Tmux session '$session_name' already exists."
        return 1
    end

    tmux new-session -d -s "$session_name"
    tmux attach -t "$session_name"
end


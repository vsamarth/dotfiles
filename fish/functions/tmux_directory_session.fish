function tmux_directory_session
    set -l dir (basename (pwd))
    set -l hash (pwd | md5sum | cut -d ' ' -f 1 | cut -c 1-6) 
    set -l session_name "$dir-$hash"
    tmux new-session -As "$session_name"
end
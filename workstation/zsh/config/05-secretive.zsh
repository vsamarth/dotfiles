# Use Secretive's Secure Enclave SSH agent only when its local socket exists.
_secretive_socket="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
if [[ -S "$_secretive_socket" ]]; then
  export SSH_AUTH_SOCK="$_secretive_socket"
fi
unset _secretive_socket

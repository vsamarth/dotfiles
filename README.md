# .files

## Installation
On a fresh installation, run:

```
curl -fsSL https://raw.githubusercontent.com/vsamarth/dotfiles/main/bootstrap.sh | bash
```

## Age helpers

The `bin/` directory is on PATH, so these helpers are available as commands:

```bash
aenc -i ~/.config/age/recipient.key file.txt dir/
adec -i ~/.config/age/identity.key file.txt.age dir.tar.age
```

The scripts encrypt files directly and wrap directories in `tar` before encrypting.

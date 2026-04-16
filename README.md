# .files

## Setup

To set up a new machine, follow the instructions in [instructions.md](instructions.md).

## Age helpers

The `bin/` directory is on PATH, so these helpers are available as commands:

```bash
aenc -i ~/.config/age/recipient.key file.txt dir/
adec -i ~/.config/age/identity.key file.txt.age dir.tar.age
```

The scripts encrypt files directly and wrap directories in `tar` before encrypting.

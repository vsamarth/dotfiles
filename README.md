# .files

## Setup

To set up a new machine, follow the instructions in [instructions.md](instructions.md).

For Samarth's clean workstation account on `den`, use
[WORKSTATION_SETUP.md](WORKSTATION_SETUP.md). This is the current Zsh-based profile;
`instructions.md` and the default `just setup` recipe are the older Fish-based setup.

For Kit's dedicated server Mac, `den`, use [SERVER_SETUP.md](SERVER_SETUP.md).
Its setup flow is `just server-preflight`, `just server-bootstrap`,
`just server-doctor`, and—only after the documented recovery drills—
`just server-readiness`.

## Age helpers

The `bin/` directory is on PATH, so these helpers are available as commands:

```bash
aenc -i ~/.config/age/recipient.key file.txt dir/
adec -i ~/.config/age/identity.key file.txt.age dir.tar.age
```

The scripts encrypt files directly and wrap directories in `tar` before encrypting.

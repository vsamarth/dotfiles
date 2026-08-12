# Recovery map

This file contains metadata only. Never record a password, token, private key,
recovery key, one-time code, or other secret here.

| Asset | Human authority | Recovery path | Last tested |
| --- | --- | --- | --- |
| `agent` macOS login | Samarth | Original password is held in Samarth's external password manager; `samarth` can reset the account in an emergency, but that does not recover the old login keychain | Not yet |
| FileVault | Samarth | Recovery key is held outside den in Samarth's recovery system | Not yet |
| GitHub CLI | Samarth | Reauthenticate through GitHub's secure browser flow | Not yet |
| Codex | Samarth | Reauthenticate through Codex's secure browser/device flow | Not yet |
| Tailscale | Samarth | Reauthorize den from the controlling tailnet account | Not yet |
| SSH access | Samarth | Private key remains on the controlling device; only its public key is installed on den | Not yet |
| Kit continuity | Samarth | Restore `/Users/agent/Kit` from the admin-controlled encrypted backup | Not yet |

Update the recovery path and test date after each recovery drill without adding the
underlying secret.

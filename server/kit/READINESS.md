# Server-readiness evidence

This checklist records completed drills, not secrets. Samarth checks an item only
after observing it succeed on `den`. Add the test date and a short non-secret note
where useful. `server-readiness` remains failing while any item is unchecked.

- [ ] The original `agent` password was retrieved from the external password manager
  and used successfully. Date: YYYY-MM-DD
- [ ] The FileVault recovery key was retrieved from the external recovery system
  without copying it to `den`. Date: YYYY-MM-DD
- [ ] From `samarth`, `sudo fdesetup list -extended` was reviewed and the intended
  FileVault unlock users were confirmed. Date: YYYY-MM-DD
- [ ] `samarth` was proven as the break-glass Remote Login identity before and after
  FileVault unlock. Date: YYYY-MM-DD
- [ ] Automatic login and automatic macOS installation are off; Remote Login is
  limited to `agent` and `samarth`; Remote Login Full Disk Access is off; and the
  firewall is on. Date: YYYY-MM-DD
- [ ] The exact permanent display adapter, power supply, keyboard, and Ethernet path
  worked at FileVault preboot. Date: YYYY-MM-DD
- [ ] SSH from the controlling Mac worked over the local network with the server host
  fingerprint verified at the physical console. Date: YYYY-MM-DD
- [ ] SSH from the controlling Mac worked over Tailscale after the firewall was
  enabled. Date: YYYY-MM-DD
- [ ] Tailnet access policy limits SSH to Samarth's controlling devices, and `den`'s
  node-key expiry policy was deliberately chosen. Date: YYYY-MM-DD
- [ ] A planned reboot returned to the documented operating state. Date: YYYY-MM-DD
- [ ] A cold power-loss and power-return drill returned to the documented operating
  state. Date: YYYY-MM-DD
- [ ] An encrypted backup completed and `/Users/agent/Kit` was restored to a temporary
  location and inspected. Date: YYYY-MM-DD

The accepted operating state may still require Samarth to unlock FileVault after a
restart. If the Tailscale Standalone app is used, it may also require a graphical
`agent` login. Record that deliberate limitation here rather than marking an untested
path as successful.

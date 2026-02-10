# Security Policy

## Reporting Security Issues

If you discover a security vulnerability in pxCommands, please report it responsibly by emailing **hey@codemeapixel.dev** instead of using public issue trackers.

### What to Include

When reporting a vulnerability, provide:
- A clear description of the issue and its impact.
- Affected versions or configurations.
- Steps to reproduce the vulnerability.
- Proof-of-concept code (if applicable).
- Suggested remediation (optional).

### Response Timeline

We aim to:
- Acknowledge receipt within 48 hours.
- Provide an initial assessment within 5 days.
- Release a patched version within 14 days for critical issues.
- Credit you in release notes (unless you request anonymity).

## Security Best Practices for Users

### Server Configuration

1. **Enable ACL enforcement** — Use FXServer's ACL system for robust admin control in standalone mode.
2. **Validate framework settings** — Ensure `framework` in `settings.lua` matches your actual server setup.
3. **Restrict database access** — Use role-based database credentials (ESX/QBCore).
4. **Keep FXServer updated** — Minimum version 1226 or newer recommended.

### Command Pack Safety

1. **Review external packs** — Audit command packs from third-party sources before deployment.
2. **Sandbox testing** — Test new command packs on a staging server first.
3. **Monitor logs** — Enable logging and regularly review server logs for suspicious activity.

### Development

1. **Input validation** — Always validate user input on the server side; never trust client checks.
2. **Use parameterized queries** — Avoid string concatenation in SQL; use prepared statements.
3. **Rate limiting** — Implement cooldowns for commands that consume resources or trigger actions.
4. **Audit trails** — Log sensitive admin actions (bans, kicks, teleports) with timestamps and source.

## Known Limitations

- pxCommands does not enforce encryption for command data in transit; use HTTPS proxies if needed.
- Custom command packs execute with full resource permissions; vet all code before deployment.
- vRP compatibility (if used) relies on vRP's admin framework; misconfiguration there affects pxCommands security.

## Supported Versions

Security fixes are applied to the latest release. Older versions may not receive patches; users are encouraged to update regularly.

## Scope

This policy applies to:
- Core pxCommands framework code.
- Included modules (overhead text, proximity).

This policy does not apply to:
- Third-party command packs.
- FXServer or framework bugs (report those upstream).
- Operational configuration issues.

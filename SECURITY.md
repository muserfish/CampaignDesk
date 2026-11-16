# Security and privacy

This project is designed for local use only. The source release omits personal broker data, Flex tokens, protected credentials, key rings, logs and bundled binaries.

- Run the .NET server and Python bridge bound to 127.0.0.1.
- Use IBKR TWS with read-only API enabled.
- Do not expose local API endpoints through public hosting, tunnels or port forwarding.
- Keep runtime data, backups, statements and credential stores out of version control.
- The local Flex credential feature stores encrypted tokens under the local user; encrypted tokens and encryption keys must never be published.
- If any real secret is accidentally committed, revoke or rotate it before considering repository cleanup.

This review covers the supplied ZIP only, not any previous Git history or local files outside the ZIP.

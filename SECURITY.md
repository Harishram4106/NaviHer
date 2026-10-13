# Security Policy

## Supported Versions

NaviHer AI is currently an **open-source prototype**. Only the latest version on `main` receives security attention.

| Version | Supported          |
| ------- | ------------------ |
| latest (main) | ✅ Yes |
| older tags | ❌ No  |

## Reporting a Vulnerability

> **Do NOT open a public GitHub issue for security vulnerabilities.**

If you discover a security vulnerability, please email the maintainers privately:

1. Describe the vulnerability and its potential impact.
2. Include reproduction steps where possible.
3. Allow a reasonable time for a fix before public disclosure.

We aim to acknowledge reports within **72 hours** and to release a fix or mitigation within **14 days** for confirmed critical issues.

## Scope

This prototype **does not** operate real emergency services or collect real personal location data. The emergency SOS and location-sharing flows are **fully simulated in-app**. There is no server component included in this repository by default.

If you are connecting NaviHer to your own Supabase backend, please follow [Supabase's security best practices](https://supabase.com/docs/guides/auth) for managing Row-Level Security (RLS) and API keys.

# Security Policy

## Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

The SkinCare.ai team takes security bugs seriously. We appreciate your efforts to responsibly disclose your findings.

### How to Report

**Please do NOT report security vulnerabilities through public GitHub issues.**

Instead, please report them via one of the following methods:

1. **GitHub Security Advisory** (Preferred):
   - Navigate to the Security tab in the repository
   - Click "Report a vulnerability"
   - Fill out the advisory form with details

2. **Email**:
   - Send details to: [security@skincare-ai.com] (or create a GitHub issue marked as security)
   - Include "SECURITY" in the subject line

### What to Include

When reporting a vulnerability, please include:

- **Type of issue** (e.g., buffer overflow, SQL injection, cross-site scripting, etc.)
- **Full paths of source file(s)** related to the manifestation of the issue
- **Location of the affected source code** (tag/branch/commit or direct URL)
- **Step-by-step instructions to reproduce the issue**
- **Proof-of-concept or exploit code** (if possible)
- **Impact of the issue**, including how an attacker might exploit it

This information will help us triage your report more quickly.

### What to Expect

After you submit a report, here's what happens:

1. **Acknowledgment**: We'll confirm receipt within 48 hours
2. **Investigation**: We'll investigate and determine the severity
3. **Updates**: We'll keep you informed about our progress
4. **Resolution**: We'll work on a fix and notify you when it's ready
5. **Disclosure**: We'll coordinate with you on public disclosure

### Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Fix Timeline**: Varies based on severity
  - Critical: 1-7 days
  - High: 7-14 days
  - Medium: 14-30 days
  - Low: 30-90 days

## Security Best Practices

### For Users

1. **Keep the app updated** to the latest version
2. **Review permissions** - Only grant necessary permissions
3. **Protect your device** - Use device encryption and strong passwords
4. **Be cautious with API keys** - Never share your Gemini API key
5. **Report suspicious behavior** immediately

### For Contributors

1. **Never commit secrets** (API keys, passwords, tokens)
2. **Use environment variables** for sensitive configuration
3. **Follow secure coding practices**:
   - Validate all user inputs
   - Use parameterized queries
   - Implement proper authentication/authorization
   - Use HTTPS for all network communications
4. **Review dependencies** for known vulnerabilities
5. **Enable 2FA** on your GitHub account

## Security Features

SkinCare.ai implements several security measures:

### Data Privacy

- **On-device processing**: Scan images are processed locally when possible
- **No persistent storage**: Photos are not stored permanently
- **Encrypted storage**: User data in UserDefaults is on encrypted storage
- **No third-party tracking**: We don't share data with advertisers

### API Security

- **API key protection**: Keys are not hardcoded in the codebase
- **Environment-based configuration**: Support for secure key management
- **Rate limiting**: Prevents abuse of AI analysis features
- **Input validation**: All inputs are validated before processing

### Code Security

- **No eval/exec**: Dynamic code execution is avoided
- **Input sanitization**: User inputs are properly sanitized
- **Dependency auditing**: Regular security audits of dependencies
- **Least privilege**: App requests minimal permissions

## Responsible Disclosure

We believe in responsible disclosure and will:

- Work with security researchers to verify and fix issues
- Give credit to researchers who report valid vulnerabilities (unless they prefer anonymity)
- Coordinate disclosure timing to ensure users are protected
- Provide security advisories for significant vulnerabilities

## Vulnerability Disclosure Policy

When we fix a security issue:

1. We'll release a patch as soon as possible
2. We'll publish a security advisory
3. We'll credit the researcher (if they wish)
4. We'll update this document with lessons learned

## Security Hall of Fame

We recognize security researchers who responsibly disclose vulnerabilities:

*None yet - be the first!*

## Legal

We will not pursue legal action against security researchers who:

- Act in good faith
- Avoid privacy violations and data destruction
- Report vulnerabilities promptly
- Do not exploit the vulnerability beyond demonstration
- Keep the vulnerability confidential until we've addressed it

## Questions

If you have questions about this security policy, please:

- Open a GitHub discussion
- Email the maintainers
- Create a non-security issue on GitHub

## Scope

This security policy applies to:

- **In scope**: The SkinCare.ai iOS application and its backend services
- **Out of scope**: Third-party services (Gemini API, etc.)

---

Thank you for helping keep SkinCare.ai and its users safe!

# Contributing to UAICP

Thank you for your interest in contributing to the Universal AI Communication Protocol! This document provides guidelines and instructions for contributing to the UAICP specification and reference implementations.

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

## Contributor License Agreement

Before contributing, you must sign our Contributor License Agreement (CLA). The CLA ensures that the UAICP can remain open while protecting both contributors and users.

### Why a CLA?

The CLA helps us ensure that:
- Everyone who contributes understands and agrees to the license terms under which their contributions are made
- There is clarity about how contributed IP may be used
- The project has the necessary rights to use and redistribute contributed code

## IP Disclosure

Please note that certain components of the UAICP implementation (specifically the Adaptive Router and Protocol Translation Hub) contain technology that may be subject to patent claims owned by UAICP Technologies, Inc. These patent-pending technologies are made available under FRAND licensing terms.

When contributing to these specific components, please be aware that your contributions may interact with patented technology. The interfaces for these components are openly specified, but certain implementation details may be covered by patents.

## Contribution Process

### 1. Finding Issues to Work On

- Browse the [issues list](https://github.com/ai-interoperability-foundation/uaicp/issues) to find tasks tagged as "good first issue" or "help wanted"
- Join the community discussion on our [forum](https://community.uaicp.org) to discuss potential contributions
- Review the [project roadmap](ROADMAP.md) to understand current priorities

### 2. Making Changes

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes
4. Add or update tests as necessary
5. Ensure all tests pass
6. Update documentation to reflect your changes
7. Commit your changes following our [commit message guidelines](#commit-message-guidelines)

### 3. Submitting a Pull Request

1. Push your changes to your fork: `git push origin feature/your-feature-name`
2. Open a pull request against the `main` branch of the UAICP repository
3. Fill out the pull request template with all required information
4. Sign the CLA when prompted
5. Wait for a maintainer to review your PR

### 4. Code Review Process

- At least one maintainer will review your PR
- Address any requested changes or feedback
- Once approved, a maintainer will merge your PR

## Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for our commit messages:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

Types include:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code changes that neither fix bugs nor add features
- `test`: Adding or modifying tests
- `chore`: Changes to the build process or auxiliary tools

Examples:
- `feat(discovery): add DNS-SD support to Discovery Mesh`
- `fix(translation): correct handling of nested capability objects`
- `docs(examples): add MQTT protocol integration example`

## Development Environment

See our [Developer Guide](docs/developer-guide.md) for instructions on setting up your development environment.

## Communication Channels

- **GitHub Issues**: For bug reports and feature requests
- **Community Forum**: For discussion about usage and development
- **Slack Workspace**: For real-time communication (request an invite on the forum)
- **Mailing List**: For major announcements and discussions

## License

- The UAICP specification is licensed under the [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)
- Reference implementations are provided under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)

## Questions?

If you have any questions about contributing, please reach out to the maintainers at contributors@uaicp.org or join our community forum.
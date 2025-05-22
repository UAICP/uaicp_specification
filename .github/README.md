# GitHub Repository Configuration

This document provides an overview of the GitHub repository configuration for the UAICP project repositories.

## 📁 Repository Structure

```
.github/
├── ISSUE_TEMPLATE/              # Issue templates
│   ├── bug_report.yml
│   ├── feature_request.yml
│   ├── specification_question.yml
│   ├── security_vulnerability.yml
│   ├── rfc.yml
│   └── config.yml
├── workflows/                   # GitHub Actions workflows
│   ├── ci.yml                  # Continuous Integration
│   ├── release.yml             # Release Management
│   └── validation.yml          # Document Validation
├── workflow-templates/          # Reusable workflow templates
│   ├── uaicp-standard-pipeline.yml
│   └── uaicp-standard-pipeline.properties.json
├── scripts/                     # Automation scripts
│   └── setup-repository.sh     # Repository setup automation
├── BRANCH_PROTECTION.md         # Branch protection documentation
├── CODEOWNERS                   # Code ownership definitions
└── pull_request_template.md     # Pull request template
```

## 🛡️ Branch Protection Rules

### Main Branch (`main`)
- **Required Reviews**: 2 approving reviews
- **Required Status Checks**: All CI checks must pass
- **Up-to-date Requirement**: Branches must be up-to-date
- **Code Owner Review**: Required
- **Dismiss Stale Reviews**: Enabled
- **Linear History**: Required (no merge commits)
- **Conversation Resolution**: Required
- **Signed Commits**: Required
- **Administrator Enforcement**: Enabled

### Development Branch (`develop`)
- **Required Reviews**: 1 approving review
- **Required Status Checks**: Basic CI checks
- **Force Push**: Allowed (for development flexibility)
- **Up-to-date Requirement**: Enabled

## 🔧 Workflow Overview

### Specification Repository Workflows

#### 1. Continuous Integration (`ci.yml`)
- **Triggers**: Push to main/develop, PRs to main/develop
- **Jobs**:
  - `validate-specification`: Lint markdown, check links, spell check
  - `test-reference-implementation`: Run tests on reference implementation
  - `security-scan`: Vulnerability scanning with Trivy
  - `compliance-check`: Validate required files and governance structure

#### 2. Release Management (`release.yml`)
- **Triggers**: Git tags (v*), manual dispatch
- **Jobs**:
  - `create-release`: Generate changelog and create GitHub release
  - `publish-docs`: Build and deploy documentation

### Website Repository Workflows

#### 1. Build and Test (`build-test.yml`)
- **Triggers**: Push to main/develop, PRs to main/develop
- **Jobs**:
  - `build-and-test`: Lint, type-check, build, test
  - `accessibility-test`: Automated accessibility testing with axe
  - `performance-test`: Lighthouse CI performance testing
  - `security-scan`: Security vulnerability scanning
  - `link-check`: Validate internal and external links

#### 2. Deployment (`deploy.yml`)
- **Triggers**: Push to main (production), push to develop (staging)
- **Environments**: Staging and Production with required approvals

## 📋 Issue Templates

### Specification Repository
- **Bug Report**: For reporting bugs in specification or reference implementation
- **Feature Request**: For requesting new features or enhancements
- **Specification Question**: For questions about the specification
- **Security Vulnerability**: For reporting security issues (with responsible disclosure)
- **RFC (Request for Comments)**: For proposing significant changes

### Website Repository
- **Bug Report**: For website functionality issues
- **Feature Request**: For website enhancements
- **Content Issue**: For content errors, typos, outdated information

## 👥 Code Ownership

Code ownership is defined in `.github/CODEOWNERS` files to ensure proper review requirements:

### Specification Repository
- **Global**: @rishirandhawa
- **Specification docs**: @specification-team, @technical-reviewers
- **Governance**: @governance-team
- **Reference implementation**: @implementation-team, @core-developers
- **Patent-protected components**: @patent-reviewers, @legal-team

### Website Repository
- **Global**: @rishirandhawa
- **Source code**: @frontend-team
- **Content**: @content-team, @technical-writers
- **Design**: @design-team
- **Performance critical**: @performance-team

## 🚀 Repository Setup Automation

Use the provided setup script to automatically configure repository settings:

```bash
# For specification repository
.github/scripts/setup-repository.sh owner/repo-name specification

# For website repository
.github/scripts/setup-repository.sh owner/repo-name website
```

The script configures:
- Branch protection rules
- Repository settings (merge options, features)
- Security features (vulnerability alerts, secret scanning)
- Labels for issue management
- Deployment environments (for website)

## 🔒 Security Configuration

### Automated Security Features
- **Vulnerability Alerts**: Automatic notification of security vulnerabilities
- **Dependabot**: Automatic dependency updates
- **Secret Scanning**: Detection of accidentally committed secrets
- **Code Scanning**: Static analysis for security issues

### Security Workflows
- **Trivy Scanning**: Comprehensive vulnerability scanning
- **npm Audit**: Node.js dependency vulnerability checking
- **SARIF Upload**: Security scan results integration with GitHub Security tab

## 📊 Quality Gates

### Required Status Checks (Main Branch)

#### Specification Repository
- ✅ `validate-specification`
- ✅ `test-reference-implementation`
- ✅ `security-scan`
- ✅ `compliance-check`

#### Website Repository
- ✅ `build-and-test`
- ✅ `accessibility-test`
- ✅ `performance-test`
- ✅ `security-scan`
- ✅ `link-check`

## 🎯 Performance & Accessibility Standards

### Website Quality Thresholds
- **Performance**: Minimum Lighthouse score of 80
- **Accessibility**: Minimum Lighthouse score of 90
- **Best Practices**: Minimum Lighthouse score of 80
- **SEO**: Minimum Lighthouse score of 80

### Accessibility Testing
- Automated testing with axe-core
- WCAG 2.1 AA compliance checking
- Screen reader compatibility verification

## 🏷️ Label System

### Common Labels
- `bug`, `enhancement`, `documentation`
- `good first issue`, `help wanted`
- `security`, `urgent`, `breaking-change`
- `ci/cd`, `dependencies`

### Specification-Specific Labels
- `specification`, `rfc`, `reference-impl`
- `governance`, `patent-review`

### Website-Specific Labels
- `content`, `design`, `performance`
- `accessibility`, `seo`

## 📝 Templates

### Pull Request Template
- Comprehensive checklist covering testing, documentation, and compliance
- Component-specific sections
- IP considerations (for specification repo)
- Accessibility and performance checks (for website repo)

### Issue Templates
- Structured forms with required fields
- Dropdown selections for categorization
- Validation requirements
- Guidance for responsible disclosure

## 🔄 Maintenance

### Regular Tasks
1. **Monthly**: Review and update dependencies
2. **Quarterly**: Review branch protection rules and team permissions
3. **Annually**: Review and update security policies and workflows

### Monitoring
- GitHub Security tab for vulnerability alerts
- Actions tab for workflow failures
- Insights tab for repository analytics

## 📚 Additional Resources

- [GitHub Branch Protection Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Security Features](https://docs.github.com/en/code-security)
- [UAICP Project Documentation](https://uaicp.org/docs)

---

For questions about this configuration or to suggest improvements, please open an issue or contact the repository maintainers.

# Branch Protection Configuration

This document outlines the recommended branch protection settings for this repository.

## Main Branch Protection Rules

The following settings should be configured for the `main` branch via GitHub's repository settings:

### Branch Protection Rules for `main`:

1. **Require a pull request before merging**
   - ✅ Require approvals: 2
   - ✅ Dismiss stale pull request approvals when new commits are pushed
   - ✅ Require review from code owners
   - ✅ Restrict pushes that create files that match a restricted path

2. **Require status checks to pass before merging**
   - ✅ Require branches to be up to date before merging
   - Required status checks:
     - `validate-specification`
     - `test-reference-implementation`
     - `security-scan`
     - `compliance-check`

3. **Require conversation resolution before merging**
   - ✅ All conversations on code must be resolved

4. **Require signed commits**
   - ✅ Require signed commits

5. **Require linear history**
   - ✅ Require linear history (no merge commits)

6. **Include administrators**
   - ✅ Include administrators (admins must follow these rules too)

7. **Restrict pushes**
   - ✅ Restrict pushes that create files that match a restricted path
   - Restricted paths:
     - `docs/specification/*.md` (require specification team review)
     - `governance/*.md` (require governance team review)

## Develop Branch Protection Rules

### Branch Protection Rules for `develop`:

1. **Require a pull request before merging**
   - ✅ Require approvals: 1
   - ✅ Dismiss stale pull request approvals when new commits are pushed

2. **Require status checks to pass before merging**
   - ✅ Require branches to be up to date before merging
   - Required status checks:
     - `validate-specification`
     - `test-reference-implementation`

3. **Allow force pushes**
   - ✅ Allow force pushes (for development convenience)

## Repository Ruleset Configuration

Create a repository ruleset with the following configuration:

```yaml
name: "Main Branch Protection"
target: "branch"
enforcement: "active"
conditions:
  ref_name:
    include:
      - "refs/heads/main"
rules:
  - type: "pull_request"
    parameters:
      required_approving_review_count: 2
      dismiss_stale_reviews_on_push: true
      require_code_owner_review: true
      require_last_push_approval: false
  - type: "required_status_checks"
    parameters:
      required_status_checks:
        - context: "validate-specification"
        - context: "test-reference-implementation" 
        - context: "security-scan"
        - context: "compliance-check"
      strict_required_status_checks_policy: true
  - type: "non_fast_forward"
  - type: "required_signatures"
```

## Setup Instructions

To configure these settings:

1. Go to repository Settings → Branches
2. Add a branch protection rule for `main`
3. Configure the settings as outlined above
4. Add a branch protection rule for `develop` 
5. Test the configuration with a test PR

## Automation

Consider using the GitHub CLI or Terraform to automate branch protection setup:

```bash
# Example using GitHub CLI
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["validate-specification","test-reference-implementation","security-scan","compliance-check"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":2,"dismiss_stale_reviews":true,"require_code_owner_reviews":true}' \
  --field restrictions=null
```

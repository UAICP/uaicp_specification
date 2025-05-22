#!/bin/bash

# UAICP Repository Setup Script
# This script automates the setup of GitHub repository settings for UAICP projects

set -e

REPO_OWNER=""
REPO_NAME=""
REPO_TYPE="" # "specification" or "website"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if GitHub CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) is not installed. Please install it first."
        echo "Visit: https://cli.github.com/"
        exit 1
    fi
    
    # Check if user is authenticated
    if ! gh auth status &> /dev/null; then
        print_error "Please authenticate with GitHub CLI first:"
        echo "gh auth login"
        exit 1
    fi
}

# Function to set up branch protection for main branch
setup_main_branch_protection() {
    print_status "Setting up branch protection for main branch..."
    
    if [ "$REPO_TYPE" = "specification" ]; then
        REQUIRED_CHECKS="validate-specification,test-reference-implementation,security-scan,compliance-check"
    else
        REQUIRED_CHECKS="build-and-test,accessibility-test,performance-test,security-scan,link-check"
    fi
    
    gh api repos/$REPO_OWNER/$REPO_NAME/branches/main/protection \
        --method PUT \
        --field required_status_checks="{\"strict\":true,\"contexts\":[\"$REQUIRED_CHECKS\"]}" \
        --field enforce_admins=true \
        --field required_pull_request_reviews="{\"required_approving_review_count\":2,\"dismiss_stale_reviews\":true,\"require_code_owner_reviews\":true}" \
        --field restrictions=null \
        --field allow_force_pushes=false \
        --field allow_deletions=false \
        --field required_linear_history=true \
        --field required_conversation_resolution=true
    
    print_status "Main branch protection configured successfully!"
}

# Function to set up branch protection for develop branch
setup_develop_branch_protection() {
    print_status "Setting up branch protection for develop branch..."
    
    # Create develop branch if it doesn't exist
    gh api repos/$REPO_OWNER/$REPO_NAME/git/refs \
        --method POST \
        --field ref="refs/heads/develop" \
        --field sha="$(gh api repos/$REPO_OWNER/$REPO_NAME/git/refs/heads/main --jq '.object.sha')" \
        2>/dev/null || print_warning "Develop branch may already exist"
    
    if [ "$REPO_TYPE" = "specification" ]; then
        REQUIRED_CHECKS="validate-specification,test-reference-implementation"
    else
        REQUIRED_CHECKS="build-and-test,accessibility-test"
    fi
    
    gh api repos/$REPO_OWNER/$REPO_NAME/branches/develop/protection \
        --method PUT \
        --field required_status_checks="{\"strict\":true,\"contexts\":[\"$REQUIRED_CHECKS\"]}" \
        --field enforce_admins=false \
        --field required_pull_request_reviews="{\"required_approving_review_count\":1,\"dismiss_stale_reviews\":true}" \
        --field restrictions=null \
        --field allow_force_pushes=true \
        --field allow_deletions=false
    
    print_status "Develop branch protection configured successfully!"
}

# Function to enable security features
enable_security_features() {
    print_status "Enabling security features..."
    
    # Enable vulnerability alerts
    gh api repos/$REPO_OWNER/$REPO_NAME/vulnerability-alerts \
        --method PUT
    
    # Enable automated security fixes
    gh api repos/$REPO_OWNER/$REPO_NAME/automated-security-fixes \
        --method PUT
    
    # Enable secret scanning
    gh api repos/$REPO_OWNER/$REPO_NAME/secret-scanning/alerts \
        --method PUT 2>/dev/null || print_warning "Secret scanning may not be available for this repository type"
    
    print_status "Security features enabled successfully!"
}

# Function to configure repository settings
configure_repository_settings() {
    print_status "Configuring repository settings..."
    
    gh api repos/$REPO_OWNER/$REPO_NAME \
        --method PATCH \
        --field has_issues=true \
        --field has_projects=true \
        --field has_wiki=false \
        --field has_downloads=true \
        --field allow_squash_merge=true \
        --field allow_merge_commit=false \
        --field allow_rebase_merge=false \
        --field delete_branch_on_merge=true \
        --field allow_auto_merge=true
    
    print_status "Repository settings configured successfully!"
}

# Function to set up environments
setup_environments() {
    if [ "$REPO_TYPE" = "website" ]; then
        print_status "Setting up deployment environments..."
        
        # Create staging environment
        gh api repos/$REPO_OWNER/$REPO_NAME/environments/staging \
            --method PUT \
            --field wait_timer=300 \
            --field reviewers='[{"type":"User","id":null}]' \
            --field deployment_branch_policy='{"protected_branches":false,"custom_branch_policies":true}'
        
        # Create production environment
        gh api repos/$REPO_OWNER/$REPO_NAME/environments/production \
            --method PUT \
            --field wait_timer=300 \
            --field reviewers='[{"type":"User","id":null}]' \
            --field deployment_branch_policy='{"protected_branches":true,"custom_branch_policies":false}'
        
        print_status "Deployment environments configured successfully!"
    fi
}

# Function to create labels
create_labels() {
    print_status "Creating repository labels..."
    
    # Common labels
    LABELS=(
        "bug|d73a4a|Something isn't working"
        "enhancement|a2eeef|New feature or request"
        "documentation|0075ca|Improvements or additions to documentation"
        "good first issue|7057ff|Good for newcomers"
        "help wanted|008672|Extra attention is needed"
        "question|d876e3|Further information is requested"
        "wontfix|ffffff|This will not be worked on"
        "duplicate|cfd3d7|This issue or pull request already exists"
        "invalid|e4e669|This doesn't seem right"
        "security|b60205|Security related issue"
        "urgent|ff0000|Requires immediate attention"
        "breaking-change|ff6600|Breaking change"
        "ci/cd|1f77b4|Continuous integration/deployment"
        "dependencies|0366d6|Pull requests that update a dependency file"
    )
    
    if [ "$REPO_TYPE" = "specification" ]; then
        LABELS+=(
            "specification|ff6b6b|Related to specification documents"
            "rfc|4ecdc4|Request for comments"
            "reference-impl|45b7d1|Reference implementation"
            "governance|6c5ce7|Project governance"
            "patent-review|ffa726|Requires patent review"
        )
    else
        LABELS+=(
            "content|96ceb4|Website content related"
            "design|ff9ff3|Design and UI related"
            "performance|54a0ff|Performance improvement"
            "accessibility|26de81|Accessibility improvement"
            "seo|2ed573|SEO related"
        )
    fi
    
    for label in "${LABELS[@]}"; do
        IFS='|' read -r name color description <<< "$label"
        gh api repos/$REPO_OWNER/$REPO_NAME/labels \
            --method POST \
            --field name="$name" \
            --field color="$color" \
            --field description="$description" \
            2>/dev/null || print_warning "Label '$name' may already exist"
    done
    
    print_status "Repository labels created successfully!"
}

# Main execution
main() {
    echo "🚀 UAICP Repository Setup Script"
    echo "================================="
    
    # Get repository information
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: $0 <owner/repo> <type>"
        echo "Example: $0 uaicp/specification specification"
        echo "         $0 uaicp/website website"
        exit 1
    fi
    
    IFS='/' read -r REPO_OWNER REPO_NAME <<< "$1"
    REPO_TYPE="$2"
    
    if [ "$REPO_TYPE" != "specification" ] && [ "$REPO_TYPE" != "website" ]; then
        print_error "Repository type must be 'specification' or 'website'"
        exit 1
    fi
    
    print_status "Setting up repository: $REPO_OWNER/$REPO_NAME (type: $REPO_TYPE)"
    
    # Check prerequisites
    check_gh_cli
    
    # Execute setup steps
    configure_repository_settings
    create_labels
    enable_security_features
    setup_main_branch_protection
    setup_develop_branch_protection
    setup_environments
    
    echo ""
    print_status "✅ Repository setup completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Review the branch protection settings in GitHub"
    echo "2. Add team members as collaborators"
    echo "3. Configure any additional secrets or variables"
    echo "4. Test the CI/CD pipeline with a test PR"
    echo ""
    echo "Repository URL: https://github.com/$REPO_OWNER/$REPO_NAME"
}

# Run main function
main "$@"

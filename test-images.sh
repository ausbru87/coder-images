#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test a specific image
test_image() {
    local image=$1
    local test_cmd=$2
    local description=$3

    echo -e "${BLUE}Testing: $description${NC}"
    if docker run --rm "$image" bash -c "$test_cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}"
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        return 1
    fi
}

# Track failures
FAILED_TESTS=0

echo -e "${BLUE}=== Testing Base Images ===${NC}"

for variant in ubuntu fedora ubi9; do
    image="ghcr.io/ausbru87/coder-images/coder-base-$variant:latest"
    echo -e "\n${BLUE}Testing $image${NC}"

    test_image "$image" "id coder" "User 'coder' exists" || ((FAILED_TESTS++))
    test_image "$image" "sudo echo 'test'" "Sudo access works" || ((FAILED_TESTS++))
    test_image "$image" "which git" "Git is installed" || ((FAILED_TESTS++))
    test_image "$image" "which curl" "Curl is installed" || ((FAILED_TESTS++))
    test_image "$image" "which wget" "Wget is installed" || ((FAILED_TESTS++))
    test_image "$image" "which vim" "Vim is installed" || ((FAILED_TESTS++))
done

echo -e "\n${BLUE}=== Testing DataSci Python Images ===${NC}"

for variant in ubuntu fedora ubi9; do
    image="ghcr.io/ausbru87/coder-images/coder-datasci-python-$variant:latest"
    echo -e "\n${BLUE}Testing $image${NC}"

    test_image "$image" "python3 --version" "Python is installed" || ((FAILED_TESTS++))
    test_image "$image" "python3 -c 'import numpy'" "NumPy is installed" || ((FAILED_TESTS++))
    test_image "$image" "python3 -c 'import pandas'" "Pandas is installed" || ((FAILED_TESTS++))
    test_image "$image" "python3 -c 'import scipy'" "SciPy is installed" || ((FAILED_TESTS++))
    test_image "$image" "python3 -c 'import matplotlib'" "Matplotlib is installed" || ((FAILED_TESTS++))
    test_image "$image" "jupyter --version" "Jupyter is installed" || ((FAILED_TESTS++))
done

echo -e "\n${BLUE}=== Testing Dev Node Images ===${NC}"

for variant in ubuntu fedora ubi9; do
    image="ghcr.io/ausbru87/coder-images/coder-dev-node-$variant:latest"
    echo -e "\n${BLUE}Testing $image${NC}"

    test_image "$image" "node --version" "Node.js is installed" || ((FAILED_TESTS++))
    test_image "$image" "npm --version" "npm is installed" || ((FAILED_TESTS++))
    test_image "$image" "tsc --version" "TypeScript is installed" || ((FAILED_TESTS++))
    test_image "$image" "pnpm --version" "pnpm is installed" || ((FAILED_TESTS++))
    test_image "$image" "yarn --version" "Yarn is installed" || ((FAILED_TESTS++))
done

echo -e "\n${BLUE}=== Testing Dev Go Images ===${NC}"

for variant in ubuntu fedora ubi9; do
    image="ghcr.io/ausbru87/coder-images/coder-dev-go-$variant:latest"
    echo -e "\n${BLUE}Testing $image${NC}"

    test_image "$image" "go version" "Go is installed" || ((FAILED_TESTS++))
    test_image "$image" "which gopls" "gopls is installed" || ((FAILED_TESTS++))
    test_image "$image" "which dlv" "Delve is installed" || ((FAILED_TESTS++))
done

echo -e "\n${BLUE}=== Testing Dev Rust Images ===${NC}"

for variant in ubuntu fedora ubi9; do
    image="ghcr.io/ausbru87/coder-images/coder-dev-rust-$variant:latest"
    echo -e "\n${BLUE}Testing $image${NC}"

    test_image "$image" "rustc --version" "Rust is installed" || ((FAILED_TESTS++))
    test_image "$image" "cargo --version" "Cargo is installed" || ((FAILED_TESTS++))
    test_image "$image" "cargo fmt --version" "rustfmt is installed" || ((FAILED_TESTS++))
    test_image "$image" "cargo clippy --version" "clippy is installed" || ((FAILED_TESTS++))
done

echo -e "\n${BLUE}=== Testing Dev Java Images ===${NC}"

for variant in ubuntu fedora ubi9; do
    image="ghcr.io/ausbru87/coder-images/coder-dev-java-$variant:latest"
    echo -e "\n${BLUE}Testing $image${NC}"

    test_image "$image" "java --version" "Java is installed" || ((FAILED_TESTS++))
    test_image "$image" "mvn --version" "Maven is installed" || ((FAILED_TESTS++))
    test_image "$image" "gradle --version" "Gradle is installed" || ((FAILED_TESTS++))
done

echo -e "\n${BLUE}=== Testing Infra K8s Images ===${NC}"

for variant in ubuntu fedora ubi9; do
    image="ghcr.io/ausbru87/coder-images/coder-infra-k8s-$variant:latest"
    echo -e "\n${BLUE}Testing $image${NC}"

    test_image "$image" "kubectl version --client" "kubectl is installed" || ((FAILED_TESTS++))
    test_image "$image" "helm version" "Helm is installed" || ((FAILED_TESTS++))
    test_image "$image" "k9s version" "k9s is installed" || ((FAILED_TESTS++))
    test_image "$image" "which kubectx" "kubectx is installed" || ((FAILED_TESTS++))
    test_image "$image" "kustomize version" "kustomize is installed" || ((FAILED_TESTS++))
done

echo -e "\n${BLUE}=== Testing Infra Terraform Images ===${NC}"

for variant in ubuntu fedora ubi9; do
    image="ghcr.io/ausbru87/coder-images/coder-infra-terraform-$variant:latest"
    echo -e "\n${BLUE}Testing $image${NC}"

    test_image "$image" "terraform version" "Terraform is installed" || ((FAILED_TESTS++))
    test_image "$image" "tofu version" "OpenTofu is installed" || ((FAILED_TESTS++))
    test_image "$image" "terragrunt --version" "Terragrunt is installed" || ((FAILED_TESTS++))
    test_image "$image" "tflint --version" "tflint is installed" || ((FAILED_TESTS++))
    test_image "$image" "tfsec --version" "tfsec is installed" || ((FAILED_TESTS++))
done

echo -e "\n${BLUE}=== Testing Infra Ansible Images ===${NC}"

for variant in ubuntu fedora ubi9; do
    image="ghcr.io/ausbru87/coder-images/coder-infra-ansible-$variant:latest"
    echo -e "\n${BLUE}Testing $image${NC}"

    test_image "$image" "ansible --version" "Ansible is installed" || ((FAILED_TESTS++))
    test_image "$image" "ansible-lint --version" "ansible-lint is installed" || ((FAILED_TESTS++))
done

echo -e "\n${BLUE}=== Testing Infra Cloud Images ===${NC}"

for variant in ubuntu fedora ubi9; do
    image="ghcr.io/ausbru87/coder-images/coder-infra-cloud-$variant:latest"
    echo -e "\n${BLUE}Testing $image${NC}"

    test_image "$image" "aws --version" "AWS CLI is installed" || ((FAILED_TESTS++))
    test_image "$image" "az version" "Azure CLI is installed" || ((FAILED_TESTS++))
    test_image "$image" "gcloud version" "gcloud is installed" || ((FAILED_TESTS++))
done

# Summary
echo -e "\n${BLUE}=== Test Summary ===${NC}"
if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}$FAILED_TESTS test(s) failed${NC}"
    exit 1
fi

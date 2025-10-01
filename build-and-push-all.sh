#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Building and pushing all coder images...${NC}"

# Function to build and push an image
build_and_push() {
    local dir=$1
    local name=$2
    local variant=$3
    local version=$4

    echo -e "${GREEN}Building $name-$variant:$version...${NC}"

    cd "$dir"

    if [ "$variant" == "ubuntu" ]; then
        docker build -f ubuntu.Dockerfile \
            -t ghcr.io/ausbruhn87/$name-$variant:$version \
            -t ghcr.io/ausbruhn87/$name-$variant:latest .
        docker push ghcr.io/ausbruhn87/$name-$variant:$version
        docker push ghcr.io/ausbruhn87/$name-$variant:latest
    elif [ "$variant" == "fedora" ]; then
        docker build -f fedora.Dockerfile \
            -t ghcr.io/ausbruhn87/$name-$variant:42 \
            -t ghcr.io/ausbruhn87/$name-$variant:latest .
        docker push ghcr.io/ausbruhn87/$name-$variant:42
        docker push ghcr.io/ausbruhn87/$name-$variant:latest
    elif [ "$variant" == "ubi9" ]; then
        docker build -f ubi9.Dockerfile \
            -t ghcr.io/ausbruhn87/$name-$variant:9.6 \
            -t ghcr.io/ausbruhn87/$name-$variant:latest .
        docker push ghcr.io/ausbruhn87/$name-$variant:9.6
        docker push ghcr.io/ausbruhn87/$name-$variant:latest
    fi

    cd - > /dev/null
}

# Build datasci images
echo -e "${BLUE}=== Building datasci images ===${NC}"

# datasci-python (base for other datasci images)
for variant in ubuntu fedora ubi9; do
    build_and_push "datasci/python" "coder-datasci-python" "$variant" "24.04"
done

# datasci-pytorch
for variant in ubuntu fedora ubi9; do
    build_and_push "datasci/pytorch" "coder-datasci-pytorch" "$variant" "24.04"
done

# datasci-tensorflow
for variant in ubuntu fedora ubi9; do
    build_and_push "datasci/tensorflow" "coder-datasci-tensorflow" "$variant" "24.04"
done

# datasci-ml
for variant in ubuntu fedora ubi9; do
    build_and_push "datasci/ml" "coder-datasci-ml" "$variant" "24.04"
done

# Build dev images
echo -e "${BLUE}=== Building dev images ===${NC}"

# dev-node
for variant in ubuntu fedora ubi9; do
    build_and_push "dev/node" "coder-dev-node" "$variant" "24.04"
done

# dev-go
for variant in ubuntu fedora ubi9; do
    build_and_push "dev/go" "coder-dev-go" "$variant" "24.04"
done

# dev-rust
for variant in ubuntu fedora ubi9; do
    build_and_push "dev/rust" "coder-dev-rust" "$variant" "24.04"
done

# dev-java
for variant in ubuntu fedora ubi9; do
    build_and_push "dev/java" "coder-dev-java" "$variant" "24.04"
done

# Build infra images
echo -e "${BLUE}=== Building infra images ===${NC}"

# infra-k8s
for variant in ubuntu fedora ubi9; do
    build_and_push "infra/k8s" "coder-infra-k8s" "$variant" "24.04"
done

# infra-terraform
for variant in ubuntu fedora ubi9; do
    build_and_push "infra/terraform" "coder-infra-terraform" "$variant" "24.04"
done

# infra-ansible
for variant in ubuntu fedora ubi9; do
    build_and_push "infra/ansible" "coder-infra-ansible" "$variant" "24.04"
done

# infra-cloud
for variant in ubuntu fedora ubi9; do
    build_and_push "infra/cloud" "coder-infra-cloud" "$variant" "24.04"
done

echo -e "${GREEN}All images built and pushed successfully!${NC}"

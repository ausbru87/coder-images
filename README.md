# Coder Workspace Images

This repository contains Dockerfiles for building Coder workspace images across two distributions: Ubuntu 24.04 and UBI 9.6.

## Image Structure

All images are built in layers:
1. **Base Images** (`coder-base-*`) - Minimal foundation with essential tools
2. **Specialized Images** - Built on top of base images with specific tooling

## Available Images

### Data Science Images

Built on `coder-datasci-python-*` which includes Python, Jupyter, pandas, numpy, scipy, matplotlib, seaborn, plotly, polars.

#### `coder-datasci-python-*`
- Python 3.12+ with pip
- Jupyter Lab & Notebook
- Core data science libraries: numpy, pandas, scipy, matplotlib, seaborn, plotly, polars, pyarrow

#### `coder-datasci-pytorch-*`
- Everything from datasci-python
- PyTorch, torchvision, torchaudio (CPU)
- Transformers, accelerate, datasets, tokenizers
- HuggingFace Hub
- TensorBoard, torchmetrics, lightning

#### `coder-datasci-tensorflow-*`
- Everything from datasci-python
- TensorFlow & Keras
- TensorBoard
- TensorFlow Datasets
- Keras Tuner

#### `coder-datasci-ml-*`
- Everything from datasci-python
- Classical ML: scikit-learn, XGBoost, LightGBM, CatBoost
- Hyperparameter tuning: Optuna
- Experiment tracking: MLflow, Weights & Biases
- Model interpretation: SHAP, eli5

### Development Images

Built on `coder-base-*` images.

#### `coder-dev-node-*`
- Node.js 22 LTS
- npm, pnpm, yarn
- TypeScript, ts-node
- ESLint, Prettier

#### `coder-dev-go-*`
- Go 1.23
- gopls (language server)
- Delve (debugger)
- staticcheck, goimports

#### `coder-dev-rust-*`
- Rust stable (via rustup)
- rust-analyzer, rustfmt, clippy
- cargo-watch, cargo-edit, cargo-outdated

#### `coder-dev-java-*`
- Java 21 LTS (OpenJDK)
- Maven
- Gradle 8.11

#### `coder-dev-cpp-*`
- GCC and G++
- Clang and LLVM tools
- CMake, Ninja build
- GDB and LLDB debuggers
- Valgrind, ccache
- clangd (language server)
- clang-format, clang-tidy

#### `coder-dev-python-*`
- Python 3.12
- pip, setuptools, wheel
- Code quality: black, flake8, pylint, mypy
- Testing: pytest, pytest-cov
- Development: ipython, python-lsp-server
- Common libraries: requests

### Infrastructure Images

Built on `coder-base-*` images for DevSecOps, SRE, and SysAdmin workflows.

#### `coder-infra-devops-*`
A complete DevOps/SRE toolkit combining all essential infrastructure tools:
- **Cloud CLIs**: AWS CLI (v2), Google Cloud CLI (gcloud), Azure CLI
- **Kubernetes**: kubectl, Helm, k9s, kubectx/kubens, kustomize, stern
- **OpenShift**: oc (OpenShift CLI), openshift-install
- **Infrastructure as Code**: Terraform, OpenTofu, Terragrunt, tflint, tfsec
- **Version Control**: GitHub CLI (gh)
- **Python Tools**: aws-shell, boto3
- **Standard CLI Tools**: vim, nano, less, jq, and more

## Image Naming Convention

Images are published to GitHub Container Registry and follow the pattern: `ghcr.io/ausbru87/coder-<category>-<tool>-<distro>:<version>`

Examples:
- `ghcr.io/ausbru87/coder-datasci-python-ubuntu:24.04`
- `ghcr.io/ausbru87/coder-dev-go-ubi9:9.6`
- `ghcr.io/ausbru87/coder-infra-k8s-ubuntu:24.04`

All images also have a `:latest` tag pointing to the most recent build.

## Building Images

Images are automatically built and pushed to GitHub Container Registry via GitHub Actions when changes are pushed to the `main` branch.

### Manual Build

To build individual images locally:

```bash
cd datasci/python
docker build -f ubuntu.Dockerfile -t ghcr.io/ausbru87/coder-datasci-python-ubuntu:24.04 .
```

### Using Images

Pull images from GitHub Container Registry:

```bash
docker pull ghcr.io/ausbru87/coder-datasci-python-ubuntu:latest
```

## Distribution Differences

### Ubuntu 24.04
- Debian-based, uses apt package manager
- Python 3.12
- Most widely supported for third-party software
- Best for general development workloads

### UBI 9.6 (Red Hat Universal Base Image)
- Enterprise-focused, RPM-based
- Python 3.12
- Suitable for environments requiring RHEL compatibility
- Best for enterprise deployments and Red Hat ecosystems

## User Setup

All images run as user `coder` (UID 1000) with passwordless sudo access.

## CI/CD

Images are automatically built and published using GitHub Actions:
- **Build Workflow**: Triggered on pushes to `main` branch or manually via workflow dispatch
- **Test Workflow**: Validates image functionality on pull requests
- **Registry**: All images are published to GitHub Container Registry (ghcr.io)

## License

These images are built using open-source tools and base images. Please refer to individual tool licenses for usage terms.

# Coder Workspace Images

This repository contains Dockerfiles for building Coder workspace images across three distributions: Ubuntu 24.04, Fedora 42, and UBI 9.6.

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

### Infrastructure Images

Built on `coder-base-*` images for DevSecOps, SRE, and SysAdmin workflows.

#### `coder-infra-k8s-*`
- kubectl
- Helm
- k9s
- kubectx & kubens
- kustomize
- stern (log viewer)

#### `coder-infra-terraform-*`
- Terraform 1.10
- OpenTofu 1.8
- Terragrunt
- tflint
- tfsec

#### `coder-infra-ansible-*`
- Ansible & ansible-core
- ansible-lint
- Molecule
- yamllint
- Support libraries: jmespath, netaddr, dnspython

#### `coder-infra-cloud-*`
- AWS CLI, aws-shell, boto3
- Azure CLI
- Google Cloud CLI (gcloud)

## Image Naming Convention

Images follow the pattern: `ausbruhn87/coder-<category>-<tool>-<distro>:<version>`

Examples:
- `ausbruhn87/coder-datasci-python-ubuntu:24.04`
- `ausbruhn87/coder-dev-go-fedora:42`
- `ausbruhn87/coder-infra-k8s-ubi9:9.6`

All images also have a `:latest` tag pointing to the most recent build.

## Building Images

Use the provided build script to build and push all images:

```bash
chmod +x build-and-push-all.sh
./build-and-push-all.sh
```

Or build individual images:

```bash
cd datasci/python
docker build -f ubuntu.Dockerfile -t ausbruhn87/coder-datasci-python-ubuntu:24.04 .
docker push ausbruhn87/coder-datasci-python-ubuntu:24.04
```

## Distribution Differences

### Ubuntu 24.04
- Debian-based, uses apt package manager
- Python 3.12
- Most widely supported for third-party software

### Fedora 42
- RPM-based, uses dnf package manager
- Python 3.13
- Cutting-edge packages

### UBI 9.6 (Red Hat Universal Base Image)
- Enterprise-focused, RPM-based
- Python 3.12
- Suitable for environments requiring RHEL compatibility

## User Setup

All images run as user `coder` (UID 1000) with passwordless sudo access.

## License

These images are built using open-source tools and base images. Please refer to individual tool licenses for usage terms.
# coder-images

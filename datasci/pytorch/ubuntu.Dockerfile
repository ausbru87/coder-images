FROM ghcr.io/ausbru87/coder-images/coder-datasci-python-ubuntu:latest

USER coder

# Install PyTorch and related tools
RUN pip3 install --break-system-packages \
    torch \
    torchvision \
    torchaudio \
    --index-url https://download.pytorch.org/whl/cpu

# Install PyTorch ecosystem tools
RUN pip3 install --break-system-packages \
    transformers \
    accelerate \
    datasets \
    tokenizers \
    sentencepiece \
    huggingface-hub \
    tensorboard \
    torchmetrics \
    lightning

WORKDIR /home/coder

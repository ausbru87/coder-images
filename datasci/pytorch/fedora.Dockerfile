FROM ausbruhn87/coder-datasci-python-fedora:latest

USER coder

# Install PyTorch and related tools
RUN pip3 install \
    torch \
    torchvision \
    torchaudio \
    --index-url https://download.pytorch.org/whl/cpu

# Install PyTorch ecosystem tools
RUN pip3 install \
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

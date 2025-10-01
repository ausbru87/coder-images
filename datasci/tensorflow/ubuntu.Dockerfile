FROM ghcr.io/ausbru87/coder-images/coder-datasci-python-ubuntu:latest

USER coder

# Install TensorFlow and Keras
RUN pip3 install --break-system-packages \
    tensorflow \
    keras \
    tensorboard \
    tensorflow-datasets \
    keras-tuner

WORKDIR /home/coder

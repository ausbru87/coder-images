FROM ghcr.io/ausbru87/coder-images/coder-datasci-python-ubi9:latest

USER coder

# Install TensorFlow and Keras
RUN pip3 install \
    tensorflow \
    keras \
    tensorboard \
    tensorflow-datasets \
    keras-tuner

WORKDIR /home/coder

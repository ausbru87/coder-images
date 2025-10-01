FROM ausbruhn87/coder-datasci-python-fedora:latest

USER coder

# Install TensorFlow and Keras
RUN pip3 install \
    tensorflow \
    keras \
    tensorboard \
    tensorflow-datasets \
    keras-tuner

WORKDIR /home/coder

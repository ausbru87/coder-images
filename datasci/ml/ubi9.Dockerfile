FROM ghcr.io/ausbru87/coder-datasci-python-ubi9:latest

USER coder

# Install classical ML libraries
RUN pip3 install \
    scikit-learn \
    xgboost \
    lightgbm \
    catboost \
    optuna \
    mlflow \
    wandb \
    shap \
    eli5

WORKDIR /home/coder

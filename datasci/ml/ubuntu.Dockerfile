FROM ghcr.io/ausbruhn87/coder-datasci-python-ubuntu:latest

USER coder

# Install classical ML libraries
RUN pip3 install --break-system-packages \
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

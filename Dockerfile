# Utiliser une image de base Ubuntu
FROM ubuntu:22.04

ENV TZ=Europe/Paris

ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour les paquets et installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    libssl-dev \
    git \
    curl \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get upgrade -y

# Installer Rust en utilisant rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y

# Ajouter Rust au PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Vérifier l'installation de Rust
RUN rustup install stable
RUN rustup default stable

# Définir le répertoire de travail
WORKDIR /app

# Cloner le dépôt ffsend
RUN git clone https://gitlab.com/timvisee/ffsend.git

# Changer de répertoire vers ffsend
WORKDIR /app/ffsend

# Compiler et installer ffsend
RUN cargo install --path .

# Commande par défaut pour afficher l'aide de ffsend
CMD ["sh", "-c", "cp target/release/ffsend /output/ffsend && ffsend --help"]
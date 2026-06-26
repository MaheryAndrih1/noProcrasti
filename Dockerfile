FROM ubuntu:24.04

# Installer les packages nécessaires pour Flutter et le développement de base.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl \
       git \
       xz-utils \
       unzip \
       libglu1-mesa \
       software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Installer le SDK Flutter.
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter --depth 1
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"

# Précharger les dépendances Flutter et activer le support web.
RUN flutter precache --linux --web

WORKDIR /workspace
COPY pubspec.* ./
RUN flutter pub get

COPY . ./

# Par défaut, exécuter les tests. Ce conteneur sert surtout à l'automatisation de la construction et des tests.
CMD ["flutter", "test"]

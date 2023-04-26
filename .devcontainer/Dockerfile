FROM python:3.9-slim-buster

# Uncomment the line below to force a no-cache image rebuilt
# RUN echo "force no-cache"

ARG UID=1000
ARG GID=1000
ARG USER="cairo"

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    sudo \
    iproute2 \
  && python -m pip install --upgrade pip \
  && sudo apt install -y libgmp3-dev \
  && pip3 install ecdsa fastecdsa sympy \
  && pip3 install cairo-lang openzeppelin-cairo-contracts starknet-devnet==v0.5.0 \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log
  # && addgroup --gid $APP_GROUP_GID --system $APP_GROUP \
  # && adduser --system --shell /sbin/nologin -u $APP_USER_UID $APP_USER \
  # && adduser $APP_USER $APP_GROUP 

# Install NodeJS and other dependencies
RUN curl -sL https://deb.nodesource.com/setup_19.x | sudo -E bash - \
&& apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    nodejs \
    libpq-dev \
    vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

# Configure non-root user based on https://hint.io/blog/rails-development-with-docker
RUN groupadd -g $GID $USER && \
useradd -u $UID -g $USER -m $USER && \
usermod -p "*" $USER && \
usermod -aG sudo $USER && \
echo "$USER ALL=NOPASSWD: ALL" >> /etc/sudoers.d/50-$USER

USER cairo

# Install Git Cli
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install -y gh

# Install zsh
RUN sudo apt install -y zsh imagemagick jq \
&& sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Enabling Virtual Environment as recommended in https://www.cairo-lang.org/docs/quickstart.html
RUN python -m venv ~/cairo_venv && mkdir ~/.starknet_accounts && chown $USER:$USER ~/.starknet_accounts
# && source ~/cairo_venv/bin/activate

# ENV PATH /app/bin:$PATH
ENV PATH /home/cairo/.local/bin:$PATH

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
&& . "$HOME/.cargo/env"

# Install Cairo 1 Cli
RUN git clone https://github.com/starkware-libs/cairo/ ~/.cairo \ 
&& cd ~/.cairo \
&& git checkout tags/v1.0.0-alpha.6 \
&& /home/cairo/.cargo/bin/cargo build --all --release

ENV PATH /home/cairo/.cairo/target/release:$PATH

# Compile and Install Extension
RUN sudo npm install -g @vscode/vsce\
&& cd ~/.cairo/vscode-cairo \
&& npm install \
# add a fake License.txt file to bypass the prompt
&& touch LICENSE.txt \
&& vsce package \
# Copy the extension to the devcontainer extension folder
&& mkdir -p /home/cairo/.vscode-server/extensions \
&& cp -r ~/.cairo/vscode-cairo /home/cairo/.vscode-server/extensions

# Find the Cairo 1 extension on the dev container extensions and configure the Language Server Path as "/home/cairo/.cairo/target/release/cairo-language-server". Then disable and enable the extension.


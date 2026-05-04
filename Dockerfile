FROM ubuntu:24.04

# Railway/System Envs
ENV PORT=7681
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/bin:$PATH"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl wget git \
    python3 python3-pip python3-venv pipx \
    nano vim less \
    tree unzip zip tini tmux \
    ripgrep fd-find procps net-tools iputils-ping dnsutils
 
# Install Tools
RUN pipx install black && pipx install pytest && pipx install ipython

# Install latest ttyd
RUN wget -qO /usr/local/bin/ttyd \
    https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 \
  && chmod +x /usr/local/bin/ttyd

# Configs
RUN echo "fastfetch || true" >> /root/.bashrc
RUN echo "set -g mouse on" >> /root/.tmux.conf
# Optional: RUN echo "set -g status off" >> /root/.tmux.conf

EXPOSE 7681

ENTRYPOINT ["/usr/bin/tini","--"]

# Ensure USERNAME and PASSWORD variables are set in your hosting provider (e.g. Railway)
CMD ["/bin/bash","-lc","/usr/local/bin/ttyd --writable -i 0.0.0.0 -p ${PORT} -c ${USERNAME}:${PASSWORD} tmux new -A -s main"]

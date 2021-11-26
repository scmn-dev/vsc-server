FROM smcr/coder-container:1.0.2

USER coder

# Apply VS Code settings
COPY container/settings.json .local/share/code-server/User/settings.json

# Use zsh shell
ENV SHELL=/bin/zsh

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# Install VS Code extensions:
ENV INSTALL="code-server --install-extension"
RUN $INSTALL github.github-vscode-theme \
    && $INSTALL pkief.material-icon-theme \
    && $INSTALL esbenp.prettier-vscode

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY container/entrypoint.sh /usr/bin/container-entrypoint.sh
RUN sudo chmod 755 /usr/bin/container-entrypoint.sh
ENTRYPOINT ["/usr/bin/container-entrypoint.sh"]

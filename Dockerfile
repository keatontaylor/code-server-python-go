FROM codercom/code-server:latest

# Update to zsh shell
RUN sudo apt-get install zsh -y
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Setup python development
RUN sudo apt-get update
RUN sudo apt-get install python3.7-dev python3-pip nano inetutils-ping -y
RUN python3.7 -m pip install pip
RUN python3.7 -m pip install wheel

# Setup go development
RUN wget https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz -O /tmp/go.tar.gz
RUN sudo tar -C /usr/local -xzf /tmp/go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
RUN rm -rf /tmp.go.tar.gz

# Install extensions
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension eamodio.gitlens
RUN code-server --install-extension ms-vscode.go

# Other stuff
USER coder
COPY settings.json /home/coder/.local/share/code-server/User/settings.json
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /home/coder/.oh-my-zsh/plugins/zsh-autosuggestions
RUN echo "source ~/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /home/coder/.zshrc

ENTRYPOINT ["dumb-init", "code-server"]

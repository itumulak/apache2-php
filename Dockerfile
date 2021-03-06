FROM ubuntu:18.04
MAINTAINER Ian Tumulak <edden87@gmail.com>

# Install Apache and other tools
RUN apt update && \
    apt install -y apache2 apache2-utils curl vim python-pip git zsh

# Setup zsh
RUN chsh -s $(which zsh)

# Setup oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Add zsh plugins
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

COPY .zshrc /root/.zshrc

#Add Pygments
RUN pip install pygments
# RUN alias pcat='pygmentize -f terminal256 -O style=monokai -g' # Alias does not work non-interactive. Must find a workaround/hack.

# Install tzadata in advance
RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata

# Install PHP 7.3
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive && \
    apt install -y --no-install-recommends php7.3 php7.3-mysql libapache2-mod-php7.3 php7.3-cli php7.3-cgi php7.3-gd

# Apache configuration
ADD config_apache.sh /config_apache.sh
RUN chmod 755 /*.sh

# Apache access
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["/config_apache.sh"]
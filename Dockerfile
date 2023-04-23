FROM ubuntu:latest
RUN apt-get update &&  apt-get -y  upgrade && apt-get autoremove && apt-get install -y net-tools  && apt-get install -y  git software-properties-common curl

RUN apt update && \
    apt install -y -q software-properties-common nano mysql-client iputils-ping
RUN add-apt-repository ppa:ondrej/php
ENV DEBIAN_FRONTEND=noninteractive
RUN DEBIAN_FRONTEND=noninteractive apt  install -y tzdata

#Node js
ENV NODE_VERSION 16.0.0
RUN apt update\
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash\
    && . $HOME/.nvm/nvm.sh\
    && nvm install $NODE_VERSION\
    && nvm use $NODE_VERSION
ENV NODE_PATH /root/.nvm/v$NODE_VERSION/lib/node_modules
ENV PATH /root/.nvm/versions/node/v$NODE_VERSION/bin:$PATH

# install php and configure composer
RUN apt-get update && \
    apt-get install -y -q  php8.1-cli php8.1-fpm php8.1-gd php8.1-curl php8.1-mysql php8.1-mbstring php8.1-xml php8.1-zip php8.1-bcmath php8.1-soap php8.1-mongodb
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --no-cache

# install nginx and configure
RUN apt-get -y update && apt -y install nginx
COPY wordpress.conf  /etc/nginx/sites-available/wordpress.conf
RUN ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/
RUN unlink /etc/nginx/sites-enabled/default && nginx -t

WORKDIR /var/www/html
RUN mkdir /var/www/html/wordpress

COPY wordpress /var/www/html/wordpress

ADD wordpress.sh /var/www/html/

CMD sh wordpress.sh  && tail -f /dev/null


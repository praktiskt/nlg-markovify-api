FROM rocker/tidyverse
MAINTAINER Magnus Furugård <magnus.furugard@gmail.com>

RUN apt-get update -qq && apt-get install -y \ 
    git-core \ 
    libssl-dev \ 
    libcurl4-gnutls-dev \
    python \
    python-pip

COPY ./api/ /usr/local/src/markovify-api
WORKDIR /usr/local/src/markovify-api

RUN chmod 700 start.sh

# Install R packages / setup markovifyR.
RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('jsonlite')"
RUN R -e "install.packages('devtools')"
RUN R -e "devtools::install_github('abresler/markovifyR')"
RUN R -e "markovifyR::install_markovify()"

# Port 8000 for local usage, not used on Heroku.
EXPOSE 8000

ENTRYPOINT ["/usr/local/src/markovify-api/start.sh"]
CMD ["routes.R"]
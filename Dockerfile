
FROM --platform="linux/amd64" debian:bookworm
RUN apt-get update && apt-get install -y jq unzip openssl
WORKDIR /opt/gunbot
COPY bin/latest/gunthy_linux.zip install.sh ssl.config ./
RUN chmod +x install.sh
RUN unzip -d . gunthy_linux.zip
RUN rm -rf __MACOSX gunthy_linux.zip
# RUN openssl req -config ssl.config -newkey rsa:2048 -nodes -keyout localhost.key -x509 -days 365 -out localhost.crt -extensions v3_req 
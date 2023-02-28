
FROM --platform="linux/amd64" debian:bookworm
RUN apt-get update && apt-get install -y unzip openssl
WORKDIR /opt/gunbot
COPY bin/latest/gunthy_linux.zip install.sh ssl.config ./
RUN chmod +x install.sh
RUN unzip -d . gunthy_linux.zip -x "gunthy_linux/gunthy-linux" -x "__MACOSX/*"
RUN rm -rf gunthy_linux.zip
# RUN rm gunthy_linux/gunthy-linux
RUN mkdir beta
WORKDIR /opt/gunbot/beta
COPY bin/beta/gunthy-linux.zip ./
RUN unzip gunthy-linux.zip
RUN rm -rf gunthy-linux.zip
RUN mv gunthy-linux /opt/gunbot/gunthy_linux/
WORKDIR /data

# RUN openssl req -config ssl.config -newkey rsa:2048 -nodes -keyout localhost.key -x509 -days 365 -out localhost.crt -extensions v3_req 
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1

# Create app directory
WORKDIR /app

COPY startup /opt/startup

# Install Tools - nscd is a DNS Cache
RUN apt-get update \
    && apt-get install -y net-tools nano openssh-server vim curl wget tcptraceroute nscd tcpdump unzip

RUN mkdir -p /app \
    && echo "root:Docker!" | chpasswd \
    && echo "cd /app" >> /etc/bash.bashrc \
    && cd /opt/startup \
    && chmod 755 /opt/startup/init_container.sh

COPY sshd_config /etc/ssh/

COPY ./bin/Debug/netcoreapp2.1/publish .

EXPOSE 5000

ENV PORT 5000
ENV ASPNETCORE_URLS=http://0.0.0.0:5000
ENV PATH ${PATH}:/app

ENV APP_HOME "/app"
ENV HTTPD_LOG_DIR "/app/LogFiles"

# CMD [ "npm", "start" ]
ENTRYPOINT ["/opt/startup/init_container.sh"]
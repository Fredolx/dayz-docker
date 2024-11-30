# Use a lightweight base image
FROM debian:bookworm-slim

# Set environment variables
ENV STEAMCMD_DIR="/steamcmd" \
    DAYZ_SERVER_DIR="/dayzserver" \
    CONFIG_DIR="/data/config" \
    PROFILES_DIR="/data/profiles" \
    STORAGE_DIR="/data/storage" \
    EXAMPLES_DIR="/examples" \
    SCRIPTS_DIR="/scripts" 
# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    ca-certificates \
    lib32gcc-s1 \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create dirs
RUN mkdir -p "$STEAMCMD_DIR" "$DAYZ_SERVER_DIR" "$CONFIG_DIR" "$PROFILES_DIR" "$STORAGE_DIR" "$EXAMPLES_DIR" "$SCRIPTS_DIR"

# Download and install SteamCMD
WORKDIR $STEAMCMD_DIR
RUN curl -sSL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -xz

# Copy the start script into the image
COPY start.sh /scripts/start.sh
COPY example-launch.env /examples/launch.env
COPY example-serverDZ.cfg /examples/serverDZ.cfg
RUN chmod +x /scripts/start.sh

# Expose DayZ server ports
# game
EXPOSE 2302/udp
EXPOSE 2302/tcp
EXPOSE 2303/udp
EXPOSE 2303/tcp
EXPOSE 2304/udp
EXPOSE 2304/tcp
EXPOSE 2305/udp
EXPOSE 2305/tcp
# steam
EXPOSE 8766/udp
EXPOSE 8766/tcp
EXPOSE 27016/udp
EXPOSE 27016/tcp
# rcon (preferred)
EXPOSE 2310/tcp
EXPOSE 2310/udp

# Set working directory to DayZ server directory
WORKDIR $DAYZ_SERVER_DIR

# Set entry point to the start script
ENTRYPOINT ["/scripts/start.sh"]

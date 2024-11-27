# Use a lightweight base image
FROM debian:bookworm-slim

# Set environment variables
ENV STEAMCMD_DIR="/steamcmd" \
    DAYZ_SERVER_DIR="/dayzserver" \
    STEAMAPPID="223350"

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    ca-certificates \
    lib32gcc-s1 \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create directories for SteamCMD and DayZ server
RUN mkdir -p "$STEAMCMD_DIR" "$DAYZ_SERVER_DIR" /scripts

# Download and install SteamCMD
WORKDIR $STEAMCMD_DIR
RUN curl -sSL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -xz

# Copy the start script into the image
COPY start.sh /scripts/start.sh
RUN chmod +x /scripts/start.sh

# Expose DayZ server ports
# game
EXPOSE 2302/udp
EXPOSE 2303/udp
EXPOSE 2304/udp
EXPOSE 2305/udp
# steam
EXPOSE 8766/udp
EXPOSE 27016/udp
# rcon (preferred)
EXPOSE 2310

# Set working directory to DayZ server directory
WORKDIR $DAYZ_SERVER_DIR

# Set entry point to the start script
ENTRYPOINT ["/scripts/start.sh"]

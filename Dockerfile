# Stage 1: Build the binary
FROM alpine:latest AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    make \
    git

# Clone the repository
RUN git clone https://github.com/wojciech-graj/doom-ascii.git /build
WORKDIR /build

# Build the binary
RUN cd src && make

# Stage 2: Create minimal runtime environment
FROM alpine:latest

# Install dropbear SSH server
RUN apk add --no-cache dropbear

# Create necessary directories and SSH host keys
RUN dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key

# Copy the built binary from stage 1
COPY --from=builder /build/doom_ascii/doom_ascii /usr/local/bin/

# Copy doom shell script and make it executable
COPY doom_shell.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/doom_shell.sh && \
    echo "/usr/local/bin/doom_shell.sh" >> /etc/shells

# Create custom MOTD
RUN echo "··································································\n\n   (ﾉ◕ヮ◕)ﾉ*:･ﾟ✧ ~*~ WELCOME TO DOOM_ASCII! ~*~ ✧ﾟ･: *ヽ(◕ヮ◕ヽ)\n\n··································································" > /etc/motd

# Create a non-root user with custom shell
RUN adduser -D -s /usr/local/bin/doom_shell.sh doomplayer && \
    echo "doomplayer:doom" | chpasswd && \
    chown doomplayer:doomplayer /usr/local/bin/doom_shell.sh

# Create directory for WAD file with proper permissions
RUN mkdir /wad && \
    chown doomplayer:doomplayer /wad && \
    chmod 755 /wad

# Make sure the doom_ascii binary is executable
RUN chmod 755 /usr/local/bin/doom_ascii

# Copy and setup entrypoint script
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Configure dropbear to listen on port 8008
EXPOSE 8008

# Mount point for doom.wad
VOLUME ["/wad"]

# Use the entrypoint script
CMD ["/entrypoint.sh"]
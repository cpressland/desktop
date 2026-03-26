FROM docker.io/debian:trixie-20260316

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y install \
    xfce4 \
    xfce4-goodies \
    curl \
    ca-certificates \
    firefox-esr \
    xz-utils \
    tigervnc-standalone-server \
    dbus-x11 \
    x11-xserver-utils \
    xterm \
    fonts-dejavu

RUN useradd -m -s /bin/bash user
USER user
WORKDIR /home/user

RUN mkdir -p /home/user/.config/tigervnc && \
    echo "password" | vncpasswd -f > /home/user/.config/tigervnc/passwd && \
    chmod 600 /home/user/.config/tigervnc/passwd && \
    echo "#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4" > /home/user/.config/tigervnc/xstartup && \
    chmod +x /home/user/.config/tigervnc/xstartup

CMD ["vncserver", ":1", "-fg", "-localhost", "no"]

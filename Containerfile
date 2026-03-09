FROM docker.io/debian:13

ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y install \
    xfce4 \
    xfce4-goodies \
    curl \
    ca-certificates \
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

RUN mkdir -p /home/user/.bin/helium && \
    mkdir -p /home/user/.local/share/applications && \
    case ${TARGETARCH} in \
        "amd64") ARCH="x86_64" ;; \
        "arm64") ARCH="arm64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}"; exit 1 ;; \
    esac && \
    VERSION=$(curl -s https://api.github.com/repos/imputnet/helium-linux/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') && \
    curl -sSL "https://github.com/imputnet/helium-linux/releases/download/${VERSION}/helium-${VERSION}-${ARCH}_linux.tar.xz" | tar -xJvf - --strip-components=1 -C /home/user/.bin/helium && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Helium\nComment=Helium Web Browser\nExec=/home/user/.bin/helium/helium\nIcon=web-browser\nCategories=Network;WebBrowser;\nTerminal=false" > /home/user/.local/share/applications/helium.desktop

ENV PATH="/home/user/.bin/helium:${PATH}"
ENV BROWSER=helium

CMD ["vncserver", ":1", "-fg", "-localhost", "no"]

FROM docker.io/debian:13
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y install \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    firefox-esr \
    dbus-x11 \
    x11-xserver-utils \
    xterm \
    fonts-dejavu

RUN mkdir -p /root/.config/tigervnc && \
    echo "password" | vncpasswd -f > /root/.config/tigervnc/passwd && \
    chmod 600 /root/.config/tigervnc/passwd

RUN echo "#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4" > /root/.config/tigervnc/xstartup && \
    chmod +x /root/.config/tigervnc/xstartup

CMD ["vncserver", ":1", "-fg", "-localhost", "no"]

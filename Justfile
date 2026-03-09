run:
    mkdir -p ~/.cpiodesktop/mozilla
    container system start
    container image pull ghcr.io/cpressland/desktop:latest
    container stop desktop || true
    container rm desktop || true
    container run -d --memory 4G -v $HOME/.cpiodesktop/mozilla:/home/user/.mozilla --name desktop ghcr.io/cpressland/desktop:latest
    open "/System/Applications/Utilities/Screen Sharing.app" "vnc://:password@$(container inspect desktop | jq .[0].networks[0].ipv4Address -r | cut -d "/" -f1):5901"

build:
    container build --name desktop ghcr.io/cpressland/desktop:test

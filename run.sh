#!/bin/bash

container system start
container stop desktop || true
container rm desktop || true
container run -d --memory 4G --name desktop ghcr.io/cpressland/desktop:latest
open "/System/Applications/Utilities/Screen Sharing.app" "vnc://:password@$(container inspect desktop | jq .[0].networks[0].ipv4Address -r | cut -d "/" -f1):5901"

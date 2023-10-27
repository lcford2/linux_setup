#!/bin/bash

CONTAINER="botbuilt-amd64-desktop-devel"
CONTAINER_RUNNING="$(docker container inspect -f '{{.State.Running}}' "${CONTAINER}")"

if [ "${CONTAINER_RUNNING}" != "true" ]; then
	sudo docker start "${CONTAINER}"
fi

kitty --session ~/.config/kitty/botbuilt.session

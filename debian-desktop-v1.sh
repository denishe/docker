#!/bin/bash
image=debian
version=1
container=${image}-desktop-v${version}
image=$container
docker run \
	--name $container \
	-h $container \
	--tmpfs /tmp --tmpfs /var/tmp \
	--cap-add=NET_ADMIN --device /dev/net/tun --privileged \
	-p 33890:3389 -v $HOME/docker/debian-desktop:/home \
	-it $image /bin/bash -l

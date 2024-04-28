#!/bin/bash
image=debian
version=0
container=${image}-desktop-v${version}
docker run --name $container -h $container \
	--tmpfs /tmp --tmpfs /var/tmp --cap-add=NET_ADMIN --device /dev/net/tun \
	-p 33890:3389 -v $HOME/docker/debian-desktop:/home -it $image /bin/bash -l /home/packages.sh

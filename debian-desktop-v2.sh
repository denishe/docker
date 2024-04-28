#!/bin/bash
container=debian-container
image=debian-desktop:1.6

docker stop $container 
docker rm   $container
docker build -t $image  .

docker run \
	--name $container	\
	-h $container		\
	--tmpfs /tmp		\
	--tmpfs /var/tmp	\
	--cap-add=NET_ADMIN	\
	--privileged		\
	--device /dev/net/tun	\
	--device /dev/snd	\
	--device /dev/dri	\
	-p 33890:3389		\
	-v $HOME/docker/debian-desktop:/home -v /private/tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=docker.for.mac.host.internal:0 \
	-e PULSE_SERVER=docker.for.mac.localhost  \
	-v $HOME/.config/pulse:/localhome/dpimienov/.config/pulse \
	-v /var/folders/vx:/var/folders/vx \
	-d $image 

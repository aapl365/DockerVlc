# docker run --name vlc -it -v /tmp/.X11-unix:/tmp/.X11-unix -e uid=$(id -u) -e gid=$(id -g) -e DISPLAY=$ip:0 -e PULSE_SERVER=$ip --privileged vlc

FROM debian:buster

RUN apt-get update && apt-get install -y \
	pulseaudio \
	libgl1-mesa-dri # Only need for Linux gpu support\
	libgl1-mesa-glx # Only need for Linux gpu support\
	vlc \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/vlc
RUN useradd --create-home --home-dir $HOME vlc \
	&& chown -R vlc:vlc $HOME \
	&& usermod -a -G audio,video vlc

WORKDIR $HOME
USER vlc

ENTRYPOINT [ "vlc" ]

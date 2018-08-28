This repo contains instructions to enable VLC in a Docker container and forward both video and audio to an OSX/Mac host. To see video on the host from a container, we forward X11. We then forward VLC's audio through tcp using pulseaudio. 

Note that this method does not extend GPU support to the container for an OSX/Mac host.

Host requirements:  

* Docker: to run the container
* XQuartz: to enable X11 on the host
* pulseaudio: to enabl audio on the host

# Setup XQuartz (X11) on the host machine
https://fredrikaverpil.github.io/2016/07/31/docker-for-mac-and-gui-applications/

1. Download XQuartz on the host machine  
`$ brew install xquartz`

2. Start XQuartz  
`$ open -a XQuartz`

3. Enable XQuartz connections from network clients  
Click: 'Security' > 'Allow connections from network clients'

4. Find the host's ip address  
`$ ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')`

5. Allow connections to the host  
`$ xhost + $ip`

# Setup the container image
1. Cd to this repository's root directory which contains the Dockerfile

2. Build the container image  
`$ docker build -t vlc ./`

3. Run the container  
    * Make sure that $ip is correctly defined on the host (see steps above)  
    * Run the command that is commented out on the first line of the Dockerfile

# Setup pulseaudio on the host and container

1. Download pulseaudio on the host machine  
`$ brew install pulseaudio`

2. Test that pulseaudio is working  
`$ paplay <sample_sound>.wav`

3. cd to pulseaudio configurations  
`$ cd /usr/local/Cellar/pulseaudio/12.2/etc/pulse`

https://wiki.archlinux.org/index.php/PulseAudio/Examples#PulseAudio_over_network

4. Enable pulseaudio over tcp  
uncomment lines:  
load-module module-esound-protocol-tcp  
load-module module-native-protocol-tcp

5. cd to pulseaudio configurations  
`$ cd /Users/<sample_user>/.config/pulse`

6. Add the host's pulseaudio cookie to the container
`$ docker cp cookie <container_hash>:/home/vlc/.config/pulse`

7. Start pulseaudio on the host  
`$ pulseaudio`

# Sources
[Arch Linux Wiki - PulseAudio Over Network](https://wiki.archlinux.org/index.php/PulseAudio/Examples#PulseAudio_over_network)  
[Blog - Docker for Mac and GUI applications](https://fredrikaverpil.github.io/2016/07/31/docker-for-mac-and-gui-applications/)  
[Docker Forums - How to run GUI apps in containiers in osx? (docker for mac)](https://forums.docker.com/t/how-to-run-gui-apps-in-containiers-in-osx-docker-for-mac/17797)  
[Github - Docker Spotify Pulseaudio](https://github.com/terlar/docker-spotify-pulseaudio)  
[Github - Forward Host Webcam to the Container](https://github.com/tomparys/docker-skype-pulseaudio/pull/8/files?short_path=04c6e90)  
[Github - Jess Docker VLC](https://github.com/jessfraz/dockerfiles/blob/master/vlc/Dockerfile)  
[Github Issue - Trying to Start Pulseaudio Container on Ubuntu 14.04 Failed](https://github.com/jessfraz/dockerfiles/issues/38)  
[How to Expose Audio From Docker Container to a Mac?](https://stackoverflow.com/questions/40136606/how-to-expose-audio-from-docker-container-to-a-mac)  
[Stackoverflow - Run Apps Using Audio in a Docker Container](https://stackoverflow.com/questions/28985714/run-apps-using-audio-in-a-docker-container/39780130#39780130)  


echo '
APT::Install-Recommends "false";
APT::AutoRemove::RecommendsImportant "false";
APT::AutoRemove::SuggestsImportant "false";
' > /etc/apt/apt.conf.d/99_norecommends
apt update && \
apt -y install sudo locales bash-completion \
	net-tools inetutils-ping telnet nmap traceroute \
	bind9-dnsutils openssh-client \
	gpg curl wget less vim \
	apt-file apt-transport-https \
	openjdk-17-jre bzip2 zip unzip \
	xfce4 xfce4-goodies xrdp xorgxrdp xserver-xorg \
	dbus dbus-x11 \
	remmina  remmina-plugin-rdp \
	firefox-esr \
	alsa-utils mesa-utils mesa-utils-extra pavucontrol pulseaudio

curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | tee /etc/apt/sources.list.d/1password.list
mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

mkdir -p /etc/apt/keyrings
wget -qO /etc/apt/keyrings/teams-for-linux.asc https://repo.teamsforlinux.de/teams-for-linux.asc
echo "deb [signed-by=/etc/apt/keyrings/teams-for-linux.asc arch=$(dpkg --print-architecture)] https://repo.teamsforlinux.de/debian/ stable main" | tee /etc/apt/sources.list.d/teams-for-linux-packages.list

sudo apt install debian-archive-keyring
sudo apt install curl gpg apt-transport-https
curl -fsSL https://packagecloud.io/filips/FirefoxPWA/gpgkey | gpg --dearmor | tee /usr/share/keyrings/firefoxpwa-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/firefoxpwa-keyring.gpg] https://packagecloud.io/filips/FirefoxPWA/any any main" | tee /etc/apt/sources.list.d/firefoxpwa.list > /dev/null

apt update
apt -y install 1password
apt -y install teams-for-linux
apt -y install firefoxpwa

export TZ=Europe/Paris
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
apt update
apt install --yes curl software-properties-common
add-apt-repository ppa:deadsnakes/ppa


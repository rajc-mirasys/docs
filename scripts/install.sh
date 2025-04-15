# !/bin/bash
sudo apt-get install -y curl git git-lfs
sudo apt-get install -y cmake build-essential zsh neovim yasm ripgrep parallel openssh-server autossh net-tools patchelf ccache
sudo apt-get install -y libgl1 libgtk-3-dev libjpeg-dev libpng-dev libtiff-dev
sudo apt-get install -y libavformat-dev libavcodec-dev libavdevice-dev libavutil-dev libswscale-dev libswresample-dev libavfilter-dev libx264-dev libx265-dev
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio
sudo apt install -y qtbase5-dev qt5-qmake
sudo apt-get install -y libyaml-cpp-dev libeigen3-dev libtool libc6 libc6-dev libusb-1.0-0 libnuma1 libnuma-dev libxdo3
sudo apt-get install -y gcc-9 g++-9

cd $HOME/Downloads
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers && sudo make install && cd –
wget https://ffmpeg.org/releases/ffmpeg-7.1.1.tar.xz
tar -xf ffmpeg-7.1.1.tar.xz && cd ffmpeg-7.1.1
./configure --prefix=/usr/local --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --disable-static --enable-shared --enable-libx264 --enable-libx265 --enable-gpl
make -j 12 && sudo make install

sudo mkdir /usr/local/mirasys && sudo mkdir /var/log/mirasys && sudo mkdir /home/mirasys
sudo chown -R $USER:$USER /usr/local/mirasys && sudo chown -R $USER:$USER /var/log/mirasys && sudo chown $USER:$USER /home/mirasys
mkdir /usr/local/mirasys/bin && mkdir /usr/local/mirasys/nas

sudo add-apt-repository -y ppa:deadsnakes/ppa && sudo apt-get update
sudo apt-get install -y python3.13 python3.13-dev # python3.11-distutils
# For PIP install
cd ~/Downloads && wget https://bootstrap.pypa.io/get-pip.py
# python3.11 get-pip.py
# python3.11 -m pip install --upgrade virtualenv setuptools numpy

# For uv (alternative to PIP) installation
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH=$HOME/.local/bin:/usr/local/cuda/bin:$PATH

uv venv /home/mirasys/.venv-3.13 --python python3.13
source /home/mirasys/.venv-3.13/bin/activate
uv pip install ultralytics lap
uv pip install -U openvino onnx onnxruntime onnxslim requests tomli mediapipe rich
uv pip install av --no-binary av
uv pip install pyzmq scikit-image scikit-learn scipy shapely albumentations filterpy
uv pip install git+https://github.com/openai/CLIP.git 
uv pip install open-clip-torch


#FRONTEND
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL "https://download.docker.com/linux/ubuntu/gpg"| sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/docker-keyring.gpg
sudo chmod +r /etc/apt/trusted.gpg.d/docker-keyring.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/docker-keyring.gpg] https://download.docker.com/linux/ubuntu noble stable" | sudo tee -a /etc/apt/sources.list.d/docker-stable.list
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER

echo "127.0.0.1   phpmyadmin_mirasys.local" | sudo tee -a /etc/hosts
echo "127.0.0.1   mirasys_frontend_central.local" | sudo tee -a /etc/hosts
echo "127.0.0.1   mirasys_frnt.local" | sudo tee -a /etc/hosts
echo "127.0.0.1   mirasys_api_gateway.local" | sudo tee -a /etc/hosts
echo "127.0.0.1   mirasys_api_tenant_gateway.local" | sudo tee -a /etc/hosts
echo "127.0.0.1   mirasys_backend.local" | sudo tee -a /etc/hosts
echo "127.0.0.1   mirasys_stream.local" | sudo tee -a /etc/hosts
echo "127.0.0.1   traefik_mirasys.local" | sudo tee -a /etc/hosts
echo "127.0.0.1   rabbitmq.local" | sudo tee -a /etc/hosts
echo "127.0.0.1   infra.local" | sudo tee -a /etc/hosts
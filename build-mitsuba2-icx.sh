[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

read -p "This script will first install the Intel OneAPI Toolkits. Do you want to proceed? (y/n)" yn

case $yn in 
	y ) echo Downloading...;;
	n ) echo Exiting...;
		exit;;
	* ) echo Invalid response...;
		exit 1;;
esac

wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \ | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null && echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list && sudo apt update && sudo apt install -y intel-basekit && sudo apt install -y intel-hpckit && sudo apt -y install intel-aikit

read -p "This script will now install the Mitsuba2 dependencies. Do you want to proceed? (y/n)" yn

case $yn in 
	y ) echo Downloading...;;
	n ) echo Exiting...;
		exit;;
	* ) echo Invalid response...;
		exit 1;;
esac

sudo apt install -y clang-11 libc++-11-dev libc++abi-11-dev cmake ninja-build libz-dev libpng-dev libjpeg-dev libxrandr-dev libxinerama-dev libxcursor-dev python3-dev python3-distutils python3-setuptools python3-pytest python3-pytest-xdist python3-numpy python3-sphinx python3-guzzle-sphinx-theme python3-sphinxcontrib.bibtex

read -p "This script will now build Mitsuba2 with the Intel OneAPI Toolkits and Embree support. Do you want to proceed? (y/n)" yn

case $yn in 
	y ) echo Building...;;
	n ) echo Exiting...;
		exit;;
	* ) echo Invalid response...;
		exit 1;;
esac

source /opt/intel/oneapi/setvars.sh && export PATH=/opt/intel/oneapi/compiler/2023.0.0/linux/compiler/lib/intel64_lin:$PATH && export CC=icx && export CXX=icpx && cp CMakeLists-Enoki.txt ext/enoki/CmakeLists.txt && mkdir build && cd build && cmake -GNinja .. -DMTS_ENABLE_EMBREE=TRUE && ninja -j64 && mv dist mitsuba2-icc && echo Done!



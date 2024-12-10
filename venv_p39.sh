apt update && apt upgrade -y add-apt-repository ppa:deadsnakes/ppa 
apt install python3.9 python3.9-venv 
python3.9-distutils -y 
echo "python 3.9 installed!!" 
cd workspace 
python3.9 -m venv env0 
source env0/bin/activate
pip install --upgrade pip

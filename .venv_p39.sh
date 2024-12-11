echo "############ VENV SCRIPT STARTED ###########"
apt update && apt upgrade -y 
add-apt-repository ppa:deadsnakes/ppa 
apt install python3.9 python3.9-venv 
python3.9-distutils -y 
echo "python 3.9 installed!!" 
python3.9 -m venv env0 
source env0/bin/activate
echo "Python utilisé : $(which python)"
echo "Pip utilisé : $(which pip)"
pip install --upgrade pip
echo "############ VENV SCRIPT FINISHED ###########"

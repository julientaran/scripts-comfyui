echo "##### STARTED PULL ID INSTALL SCRIPT ##########"
cd ComfyUI/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
python -m pip install -r requirements.txt
cd ../..
python -m pip install --use-pep517 facexlib
python -m pip install insightface onnxruntime
echo "########## PULL ID INSTALL SCRIPT FINISHED ##########"

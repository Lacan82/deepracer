git clone  https://github.com/larsll/deepracer-for-cloud.git
cd deepracer-for-cloud/
cd bin/
nano prepare.sh 
./prepare.sh 
cd ..
sudo reboot
git clone --branch 2020_version https://github.com/richardfan1126/deepracer.git
cd deepracer
git submodule init
git submodule update
sudo apt-get install python3-venv
python3 -m venv sagemaker_venv
pip install wheel
pip install -U sagemaker-python-sdk/ awscli pandas
mkdir -p ~/.sagemaker && cp config.yaml ~/.sagemaker
nano ~/.sagemaker/config.yaml 
export LOCAL_ENV_VAR_JSON_PATH=$(readlink -f ./env_vars.json)
cd rl_coach; python rl_deepracer_coach_robomaker.py

cd sagemaker-tensorflow-container/
python setup.py sdist
wget https://files.pythonhosted.org/packages/55/7e/bec4d62e9dc95e828922c6cec38acd9461af8abe749f7c9def25ec4b2fdb/tensorflow_gpu-1.12.0-cp36-cp36m-manylinux1_x86_64.whl
docker build . -t local/sagemaker-tensorflow-container:nvidia -f docker/1.12.0/Dockerfile.gpu --build-arg framework_installable=tensorflow_gpu-1.12.0-cp36-cp36m-manylinux1_x86_64.whl --build-arg py_version=3

cd sagemaker-containers/
python setup.py sdist
cp dist/sagemaker_containers-2.4.4.post2.tar.gz ../sagemaker-rl-container/

cd sagemaker-rl-container/
docker build . -t local/sagemaker-rl-container:nvidia -f Sagemaker-rl-nvidia.docker --build-arg sagemaker_container=sagemaker_containers-2.4.4.post2.tar.gz

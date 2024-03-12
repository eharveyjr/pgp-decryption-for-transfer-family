#!/usr/bin/env bash

# Installing necessary python packages
echo Installing required packages...
cd /home/cloudshell-user
sudo dnf install python3.8 -y
sudo dnf install python3.8 gcc make glibc-static bzip2 python3-pip -y
echo Required packages installed. 
pip3 install virtualenv
python3 -m venv python
cd python
source bin/activate
pip3 install python-gnupg
deactivate
rm -rf ./bin
mkdir ./python
mv lib ./python/

# Downloading and building GPG binary from source
wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.23.tar.bz2
tar xjf gnupg-1.4.23.tar.bz2 /home/cloudshell-user/python/
cd /home/cloudshell-user/python/gnupg-1.4.23
./configure
make CFLAGS='-static'
cp g10/gpg /home/cloudshell-user/python/python
cd /home/cloudshell-user/python/python
chmod o+x gpg
cd ..
zip -r lambdaLayer.zip python/
aws lambda publish-layer-version --layer-name python-gnupg --description "Python-GNUPG Module and GPG Binary" --zip-file fileb://lambdaLayer.zip --compatible-runtimes python3.8
echo Lambda layer created successfully.

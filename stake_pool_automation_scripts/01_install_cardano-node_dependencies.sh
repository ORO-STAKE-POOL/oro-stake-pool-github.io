#!/usr/bin/env bash

# Author: ORO STAKE POOL || Telegram Channel: https://t.me/oro_pool ||DISCORD: https://discord.gg/DGZrM4VC5P
# Installs Cardano-Node dependencies:  Libsodium, CABAL, GHC
# node's location will be in $NODE_HOME. The cluster configuration is set by $NODE_CONFIG and $NODE_BUILD_NUM.

start=`date +%s.%N`

banner="--------------------------------------------------------------------------"

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install git jq \
                    bc make automake \
                    rsync htop curl \
                    build-essential pkg-config \
                    libffi-dev libgmp-dev libssl-dev \
                    libtinfo-dev libsystemd-dev zlib1g-dev \
                    make g++ wget libncursesw5 libtool autoconf -y

mkdir $HOME/git
cd $HOME/git
git clone https://github.com/input-output-hk/libsodium
pushd libsodium
git checkout 66f017f1
bash ./autogen.sh
bash ./configure
make
sudo make install

sudo ln -s /usr/local/lib/libsodium.so.23.3.0 /usr/lib/libsodium.so.23

popd
wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz
tar -xf cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz
rm -rf cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz cabal.sig
mkdir -p $HOME/.local/bin
mv -f cabal $HOME/.local/bin/


wget https://downloads.haskell.org/ghc/8.10.2/ghc-8.10.2-x86_64-deb9-linux.tar.xz
tar -xf ghc-8.10.2-x86_64-deb9-linux.tar.xz
rm -rf ghc-8.10.2-x86_64-deb9-linux.tar.xz
pushd ghc-8.10.2
bash ./configure
sudo make install

echo PATH="$HOME/.local/bin:$PATH" >> $HOME/.bashrc
echo export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" >> $HOME/.bashrc
echo export NODE_HOME=$HOME/cardano-my-node >> $HOME/.bashrc
echo export NODE_CONFIG=mainnet>> $HOME/.bashrc
echo export NODE_BUILD_NUM=$(curl https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html | grep -e "build" | sed 's/.*build\/\([0-9]*\)\/download.*/\1/g') >> $HOME/.bashrc
source $HOME/.bashrc

cabal update

end=`date +%s.%N`
runtime=$( echo "$end - $start" | bc -l ) || true

echo $banner
echo "Total Time Took To Complete: $runtime"
echo "Installed CABAL Version: $(cabal -V)"
echo "Installed GHC version: $(ghc -V)"
echo $banner

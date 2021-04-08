#!/usr/bin/env bash

# Author: ORO STAKE POOL || Telegram Channel: https://t.me/oro_pool || DISCORD: https://discord.gg/DGZrM4VC5P
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
                    make g++ wget libncursesw5 libtool autoconf libncurses-dev libtinfo5 -y

mkdir $HOME/git
cd $HOME/git
git clone https://github.com/input-output-hk/libsodium
cd libsodium
git checkout 66f017f1
bash ./autogen.sh
bash ./configure
make
sudo make install

sudo ln -s /usr/local/lib/libsodium.so.23.3.0 /usr/lib/libsodium.so.23

export BOOTSTRAP_HASKELL_NONINTERACTIVE=true

curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

GHCUP_PROFILE_FILE="$HOME/.bashrc"

GHCUP_DIR=$HOME/.ghcup

echo "[ -f \"${GHCUP_DIR}/env\" ] && source \"${GHCUP_DIR}/env\" # ghcup-env" >> "${GHCUP_PROFILE_FILE}"

eval "$(cat "${GHCUP_PROFILE_FILE}" | tail -n +10)"
ghcup upgrade
ghcup install ghc 8.10.4
ghcup set ghc 8.10.4

echo PATH="$HOME/.local/bin:$PATH" >> $HOME/.bashrc
echo export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" >> $HOME/.bashrc
echo export NODE_HOME=$HOME/cardano-my-node >> $HOME/.bashrc
echo export NODE_CONFIG=mainnet>> $HOME/.bashrc
echo export NODE_BUILD_NUM=$(curl https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html | grep -e "build" | sed 's/.*build\/\([0-9]*\)\/download.*/\1/g') >> $HOME/.bashrc
eval "$(cat $HOME/.bashrc | tail -n +10)"

cabal update

end=`date +%s.%N`
runtime=$( echo "$end - $start" | bc -l ) || true

echo $banner
echo "Total Time Took To Complete Script: $runtime seconds"
echo "Installed CABAL Version: $(cabal -V)"
echo "Installed GHC version: $(ghc -V)"
echo "Node Location: $NODE_HOME"
echo $banner

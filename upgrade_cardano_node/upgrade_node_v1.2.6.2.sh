#!/usr/bin/env bash

# Author: ORO STAKE POOL || Telegram Channel: https://t.me/oro_pool || DISCORD: https://discord.gg/DGZrM4VC5P
# Update cardano-node version to 1.26.2
# Official release notes: https://github.com/input-output-hk/cardano-node/releases/tag/1.26.2

start=`date +%s.%N`

banner="--------------------------------------------------------------------------"

error(){
  printf "\n Error:  Exiting"
  ls -ltr; pwd
  exit 1
}

mkdir -p ${HOME}/git
cd ${HOME}/git || error

if [ -d $HOME/git/cardano-node-old ]; then
        echo "Removing old binaries: cardano-node-old"
        rm -rf $HOME/git/cardano-node-old
        ls -ltr $HOME/git/
fi

mv -vf ${HOME}/git/cardano-node ${HOME}/git/cardano-node-old || true
git clone https://github.com/input-output-hk/cardano-node.git || error
cd cardano-node || error

cabal update

git fetch --all --recurse-submodules --tags
git checkout tags/1.26.2
cabal configure -O0 -w ghc-8.10.4
echo -e "package cardano-crypto-praos\n flags: -external-libsodium-vrf" > cabal.project.local
cabal build cardano-node cardano-cli

$(find $HOME/git/cardano-node/dist-newstyle/build -type f -name "cardano-cli") version
$(find $HOME/git/cardano-node/dist-newstyle/build -type f -name "cardano-node") version

sudo systemctl stop cardano-node

#Wait until node is stopped
sleep 5s

sudo cp $(find $HOME/git/cardano-node/dist-newstyle/build -type f -name "cardano-cli") /usr/local/bin/cardano-cli

sudo cp $(find $HOME/git/cardano-node/dist-newstyle/build -type f -name "cardano-node") /usr/local/bin/cardano-node

sudo systemctl start cardano-node

end=`date +%s.%N`
runtime=$( echo "$end - $start" | bc -l ) || true

echo $banner
echo "Total Time Took To Complete Script: $runtime seconds"
echo "Node Location: $NODE_HOME"
echo "cardano-node version: $(cardano-node version)"
echo "cardano-cli version: $(cardano-cli version)"
echo $banner

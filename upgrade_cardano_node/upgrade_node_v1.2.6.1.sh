#!/usr/bin/env bash

# Author: ORO STAKE POOL || Telegram Channel: https://t.me/oro_pool || DISCORD: https://discord.gg/DGZrM4VC5P
# Update cardano-node version to 1.26.1
# Official release notes: https://github.com/input-output-hk/cardano-node/releases/tag/1.26.1

start=`date +%s.%N`

banner="--------------------------------------------------------------------------"

error(){
  printf "\n Error:  Exiting"
  ls -ltr; pwd
  exit 1
}

cd ${HOME}/git || error
mv -vf ${HOME}/git/cardano-node ${HOME}/git/cardano-node-old || error
git clone https://github.com/input-output-hk/cardano-node.git || error
cd cardano-node || error

if [ -n "$(command -v apt-get)" ]; then
  sudo apt-get -y install pkg-config libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev \
                  build-essential curl libgmp-dev libffi-dev libncurses-dev libtinfo5
elif [ -n "$(command -v apt-get)" ]; then
  yum install -y --setopt=tsflags=nodocs \
           pkg-config libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev \
           build-essential curl libgmp-dev libffi-dev libncurses-dev libtinfo5
else
  echo "Could not identify package manager; exiting"
  exit 1
fi

export BOOTSTRAP_HASKELL_NONINTERACTIVE=true
GHCUP_DIR=$HOME/.ghcup

curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

case $SHELL in
		*/zsh) # login shell is zsh
			GHCUP_PROFILE_FILE="$HOME/.zshrc"
			MY_SHELL="zsh" ;;
		*/bash) # login shell is bash
			GHCUP_PROFILE_FILE="$HOME/.bashrc"
			MY_SHELL="bash" ;;
		*/sh) # login shell is sh, but might be a symlink to bash or zsh
			if [ -n "${BASH}" ] ; then
				GHCUP_PROFILE_FILE="$HOME/.bashrc"
				MY_SHELL="bash"
			elif [ -n "${ZSH_VERSION}" ] ; then
				GHCUP_PROFILE_FILE="$HOME/.zshrc"
				MY_SHELL="zsh"
			else
			    echo "All done!"
			fi
			;;
		*/fish) # login shell is fish
			GHCUP_PROFILE_FILE="$HOME/.config/fish/config.fish"
			MY_SHELL="fish" ;;
		*) echo "All done!" ;;
esac

case $MY_SHELL in
					fish)
						if ! grep -q "ghcup-env" "${GHCUP_PROFILE_FILE}" ; then
							mkdir -p "${GHCUP_PROFILE_FILE%/*}"
							echo "# ghcup-env" >> "${GHCUP_PROFILE_FILE}"
							echo "set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX \$HOME" >> "${GHCUP_PROFILE_FILE}"
							echo "test -f $GHCUP_DIR/env ; and set -gx PATH \$HOME/.cabal/bin $GHCUP_BIN \$PATH" >> "${GHCUP_PROFILE_FILE}"
						fi;;
					bash)
						if ! grep -q "ghcup-env" "${GHCUP_PROFILE_FILE}" ; then
							echo "[ -f \"${GHCUP_DIR}/env\" ] && source \"${GHCUP_DIR}/env\" # ghcup-env" >> "${GHCUP_PROFILE_FILE}"
						fi;;
					zsh)
						if ! grep -q "ghcup-env" "${GHCUP_PROFILE_FILE}" ; then
							echo "[ -f \"${GHCUP_DIR}/env\" ] && source \"${GHCUP_DIR}/env\" # ghcup-env" >> "${GHCUP_PROFILE_FILE}"
						fi;;
esac

eval "$(cat "${GHCUP_PROFILE_FILE}" | tail -n +10)"
ghcup upgrade
ghcup install ghc 8.10.4
ghcup set ghc 8.10.4

cd $HOME/git/cardano-node || error
cabal update
rm -rf $HOME/git/cardano-node/dist-newstyle/build/x86_64-linux/ghc-8.10.2
rm -rf $HOME/git/cardano-node/dist-newstyle/build/x86_64-linux/ghc-8.10.4
git fetch --all --recurse-submodules --tags
git checkout tags/1.26.1
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
echo "Installed CABAL Version: $(cabal -V)"
echo "Installed GHC version: $(ghc -V)"
echo "Node Location: $NODE_HOME"
echo "cardano-node version: $(cardano-node version)"
echo "cardano-cli version: $(cardano-cli version)"
echo $banner

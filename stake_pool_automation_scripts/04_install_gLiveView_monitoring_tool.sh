#!/usr/bin/env bash
# Author: ORO STAKE POOL || Telegram Channel: https://t.me/oro_pool || DISCORD: https://discord.gg/DGZrM4VC5P
# Install gLiveView Monitoring tool

start=`date +%s.%N`

banner="--------------------------------------------------------------------------"

eval "$(cat $HOME/.bashrc | tail -n +10)"


cd $NODE_HOME
sudo apt install bc tcptraceroute -y
curl -s -o gLiveView.sh https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/gLiveView.sh
curl -s -o env https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/env
chmod 755 gLiveView.sh

sed -i env \
    -e "s/\#CONFIG=\"\${CNODE_HOME}\/files\/config.json\"/CONFIG=\"\${NODE_HOME}\/mainnet-config.json\"/g" \
    -e "s/\#SOCKET=\"\${CNODE_HOME}\/sockets\/node0.socket\"/SOCKET=\"\${NODE_HOME}\/db\/socket\"/g"

end=`date +%s.%N`
runtime=$( echo "$end - $start" | bc -l ) || true

echo $banner
echo "Total Time Took To Complete Script: $runtime seconds"
echo "gLiveView is installed under Directory : $NODE_HOME/gLiveView.sh"
echo $banner


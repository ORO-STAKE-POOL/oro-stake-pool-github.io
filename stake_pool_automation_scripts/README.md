## Please read the [Official documentation](https://docs.cardano.org/projects/cardano-node/en/latest/index.html) to understand the configuration files and different properties.

## Installs Cardano-Node Version - 1.26.1 

### SSH command run from MAC/Unix terminal

```bash
ssh -i <location to pem file> username@public_ip_adress
```

### clone git repository
```bash
git clone https://github.com/ORO-STAKE-POOL/oro-stake-pool-github.io.git
chmod +x oro-stake-pool-github.io/stake_pool_automation_scripts/*
```

### Run script 01_install_cardano-node_dependencies
```bash
./oro-stake-pool-github.io/stake_pool_automation_scripts/01_install_cardano-node_dependencies.sh
```

### Run script 02_build_node_from_source_code
```bash
nohup ./oro-stake-pool-github.io/stake_pool_automation_scripts/02_build_node_and_configure.sh &
```

### Run script 03_create_startup_scripts
```bash
./oro-stake-pool-github.io/stake_pool_automation_scripts/03_create_startup_scripts.sh
```
##### Your cardano-node is up and running!!
> Verify status of the node - `sudo systemctl status cardano-node`

> Restart node service - `sudo systemctl reload-or-restart cardano-node`

> Stop node service - `sudo systemctl stop cardano-node`

> View Node logs - `journalctl --unit=cardano-node --follow`

### Run script 04_install_gLiveView_monitoring_tool
```bash
./oro-stake-pool-github.io/stake_pool_automation_scripts/04_install_gLiveView_monitoring_tool.sh
```

### Check DB Sync Status
```bash
bash $NODE_HOME/gLiveView.sh
```

----

#### Wait until DB sync is completed 100%, Create an AMI from the main-node, we will use this AMI to provision relay nodes

----

### Stop Cardano-node
```bash
sudo systemctl stop cardano-node
```

### Update mainnet-topology.json file with relay node's Public elastic IP address on main_node
```bash
cat > $NODE_HOME/${NODE_CONFIG}-topology.json << EOF 
 {
    "Producers": [
      {
        "addr": "<RELAYNODE'S PUBLIC IP ADDRESS>",
        "port": 6000,
        "valency": 1
      }
    ]
  }
EOF
```
### Start Cardano-node
```bash
sudo systemctl start cardano-node
```
### Run script 05_generate_keys_on_main_node on main_node
```bash
./oro-stake-pool-github.io/stake_pool_automation_scripts/05_generate_keys_on_main_node.sh
```

### Run script 06_create_payment_stake_keys on main_mode
```bash
./oro-stake-pool-github.io/stake_pool_automation_scripts/06_create_payment_stake_keys.sh
```

### Run script 07_register_stake_address
```bash
./oro-stake-pool-github.io/stake_pool_automation_scripts/07_register_stake_address.sh
```



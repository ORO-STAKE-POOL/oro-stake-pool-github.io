> ## Please read the [Official documentation](https://docs.cardano.org/projects/cardano-node/en/latest/index.html) to understand the configuration files and different properties.

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
nohup ./oro-stake-pool-github.io/stake_pool_automation_scripts/02_build_node_from_source_code.sh &
```

### Run script 03_create_startup_scripts
```bash
./oro-stake-pool-github.io/stake_pool_automation_scripts/03_create_startup_scripts.sh
```
#### Your cardano-node is up and running!!
> Verify status of the node - `sudo systemctl status cardano-node`

> Restart node service - `sudo systemctl reload-or-restart cardano-node`

> Stop node service - `sudo systemctl stop cardano-node`

> View Node logs - `journalctl --unit=cardano-node --follow`

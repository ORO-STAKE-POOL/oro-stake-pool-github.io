[Official release notes](https://github.com/input-output-hk/cardano-node/releases/)

## Upgrade Cardano-Node Version - 1.26.1 (latest)

[![Cardano Stake Pool in AWS](http://www.oroops.com.s3-website-us-east-1.amazonaws.com/images/upgrade_node.png)](https://youtu.be/9Y6ZRZB4s_o)

### SSH to the relay/main node

```bash
ssh -i <location of the pem file> username@public_ip_adress
```

### clone git repository
```bash
git clone https://github.com/ORO-STAKE-POOL/oro-stake-pool-github.io.git
chmod +x oro-stake-pool-github.io/upgrade_cardano_node/*
```

### Run script upgrade_node_v1.2.6.1.sh in the background - script takes few hours :timer_clock: to complete
```bash
nohup ./oro-stake-pool-github.io/upgrade_cardano_node/upgrade_node_v1.2.6.1.sh &
```
* `jobs` command will display status of the scripts that are running in the background 

* Display execution output of the `upgrade_node_v1.2.6.1.sh` script -  `tail -f nohup.out`

Congratulations! Your Cardano Node is upgraded to the latest version. :partying_face:

##### Note : Future upgrade scripts can be pulled by running `git pull` command.
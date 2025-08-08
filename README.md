# How to create a Ntity node

Ntity is a blockchain. We use docker to deploy node to interact with the Ntity blockchain. To create a node you need to execute the following rules. 



## Requirement

You need the following package to build and execute a Ntity node

1. First you need to install docker docker-compose and git if you already have it you can go to 
2. To install docker please use this :

```bash
sudo apt-get install docker.io docker-compose git	
```

You need to execute this command to use docker without `sudo`

```bash
sudo usermod -aG docker [username]
```

Clone the repository

```bash
git clone https://github.com/ntity-core/node.git
```

## updater
in the node folder
```bash
(crontab -l ; echo "0 0 * * * $(which python3) $(pwd)/update/approuval.py") | crontab -
```


## Nethermind
- Change password -> Nethermind\password.txt
- Change name node -> config.cfg -> EthStats -> Name


### Use an other wallet

if xxd software doesn't exist, install it.

```bash
sudo mv node.key.plain node.key.plain.bckp
echo -n "4cccc private key without 0x ...." | xxd -r -p | sudo tee node.key.plain > /dev/null
```

### Start node

On the first start

```bash
docker-compose -f nethermind.yml up
```

And for other start 

```bash
docker-compose -f nethermind.yml start
```

### Stop node

If you have the output you need to use `crtl + c` to close and have access to the console

For the both usage you need to down the docker-compose 

```bash
docker-compose -f nethermind.yml stop
```

### Reset all node

With the docker-compose down add option `-v`

```bash
docker-compose -f nethermind.yml down -v
```

### Update node

You need to stop the node. Pull the new image and restart the node

```bash
docker-compose -f nethermind.yml down
docker pull nethermind/nethermind:latest
docker-compose -f nethermind.yml up
```

## Geth

### Create a node

Create one folder for the node you want to run. 

```bash
sudo mkdir -p /data/blockchain/ntity-01
```

And copy `ntity.genesis.json` into `/data/blockchain/`

```bash
sudo cp ./files/ntity.genesis.json /data/blockchain/
```

### Image
All the image is on docker hub. 

- latest is for amd64
- arm64v8 is for raspberry pi 4 8go
- arm32v7 is for raspberry pi 3B

For this tutorial we use latest you can change for the tag you want by replacing latest by the tag.

You need to pull the image you want to continue the installation node

```bash
sudo docker pull ethereum/client-go:v1.13.10
```

### Create a new wallet

First you need to create a wallet

```bash
sudo docker run -it -v "/data/blockchain/ntity-01:/ethereum" ethereum/client-go:v1.13.10 geth --datadir=/ethereum account new
```

Copy the public key it's look like `0x24B72AeDBb3f9d97d14F59E4EF53Cf5B190De293` you will need in the next step

```bash
sudo mkdir /data/blockchain/password/
echo  'myWalletPassword' | sudo tee /data/blockchain/password/password.txt


Once you created a new wallet you can change it into the docker file on WALLET environnement variable with wallet
this is an example : 
```bash
sed -i 's/0x57616c6c6574/0x24B72AeDBb3f9d97d14F59E4EF53Cf5B190De293/' ntity.yml
```


### Init genesis (only for new node)

You need to init for each node the genesis block

First you need to copy the genesis block in the ntity folder

```bash
sudo cp /data/blockchain/ntity.genesis.json /data/blockchain/ntity-01
```

```bash
sudo docker run -it -v "/data/blockchain/ntity-01:/blockchain" ethereum/client-go:v1.13.10 --datadir=/blockchain init /blockchain/ntity.genesis.json
```

### Start node

before starting your new node you need to change the name in `files/app.json`. The default value is `nttMiner` replace it with a new name.

On the first start

```bash
docker-compose -f ntity.yml up
```

And for other start 

```bash
docker-compose -f ntity.yml start
```

### Stop node

If you have the output you need to use `crtl + c` to close and have access to the console

For the both usage you need to down the docker-compose 

```bash
docker-compose -f ntity.yml stop
```

### Reset all node

With the docker-compose down add option `-v`

```bash
docker-compose -f ntity.yml down -v
```

### Update node

You need to stop the node. Pull the new image and restart the node

```bash
docker-compose -f ntity.yml down
docker pull ntity/node
docker-compose -f ntity.yml up
```


# Metamask: Add Ntity Network
```
Network Name : Ntity
RPC URL : https://rpc.ntity.io
Chain ID: 197710212030 || 0x2E08726BBE
Symbol : NTT
Decimal : 18
Explorer : http://blockscout.ntity.io
```

# Metamask: Add Haradev Network (testnet)
```
Network Name : Ntity Haradev
RPC URL : https://blockchain.haradev.com
Chain ID: 197710212031 || 0x2E08726BBF
Symbol : NTTH
Decimal : 18
Explorer : http://blockscout.haradev.com
```



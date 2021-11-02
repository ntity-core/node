# How to create a Ntity node

Ntity is a blockchain. We use docker to deploy node to interact with the Ntity blockchain. To create a node you need to execute the following rules. You have two option to create a node. The first one is follow the tutoriel. The second one is run the script `run.sh`

## Requirement

You need the following package to build and execute a Ntity node

1. First you need to install docker docker-compose and git if you already have it you can go to 2. To install docker please use this :

```bash
sudo apt-get install docker.io docker-compose git	
```

You need to execute this command to use docker without `sudo`

```bash
sudo usermod -aG docker [username]
```

## Create a node

Clone the repository

```bash
git clone https://github.com/ntity-core/node.git
```

And create one folder for the node you want to run. 

```bash
sudo mkdir -p /data/blockchain/ntity-01
```

And copy `ntity.genesis.json` and `static-nodes.json` into `/data/blockchain/`

```bash
sudo cp ./files/ntity.genesis.json /data/blockchain/
sudo cp ./files/static-nodes.json /data/blockchain/
```

## Image
All the image is on docker hub. 

- latest is for amd64
- arm64v8 is for raspberry pi 4 8go
- arm32v7 is for raspberry pi 3B

For this tutorial we use latest you can change for the tag you want by replacing latest by the tag.

## Create a new wallet

First you need to create a wallet

```bash
sudo docker run -it -v "/data/blockchain/ntity-01:/ethereum" ntity/blockchain:latest geth --datadir=/ethereum --nousb account new
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


## Init genesis (only for new node)

You need to init for each node the genesis block

First you need to copy the genesis block in the ntity folder

```bash
sudo cp /data/blockchain/ntity.genesis.json /data/blockchain/ntity-01
```

```bash
sudo docker run -it -v "/data/blockchain/ntity-01:/blockchain" ntity/blockchain geth --datadir=/blockchain --nousb init /blockchain/ntity.genesis.json
```

## Start node

before starting your new node you need to change the name in `files/app.json`. The default value is `nttMiner` replace it with a new name.

On the first start

```bash
docker-compose -f ntity.yml up
```

And for other start 

```bash
docker-compose -f ntity.yml start
```

## Stop node

If you have the output you need to use `crtl + c` to close and have access to the console

For the both usage you need to down the docker-compose 

```bash
docker-compose -f ntity.yml stop
```

## Reset all node

With the docker-compose down add option `-v`

```bash
docker-compose -f ntity.yml down -v
```

## Get Enode

To get the enode once you started the node a new file `enode.txt` will be create in `/data/blockchain/ntity-01/`. You can get the data with 

```bash
cat /data/blockchain/ntity-01/enode.txt
```

it's look like that
`enode://dd7dbcee4e739cfff236b2cae51559d44b4c18524c8aa78ffca3ea49f3b36184eafb08597c4414c20fdcf1548de924585b15a6247a9a719c85431b10168feff4@127.0.0.1:30303`

Add your ipv4 public to replace 127.0.0.1


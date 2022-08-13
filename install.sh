#!/bin/bash

i=0
docker version > /dev/null 2>&1 && i=1
if [ $i -ne 1 ];then
    echo "Do you wish to install docker?"
    select yn in "Yes" "No" "Exit"; do
        case $yn in
            Yes ) sudo apt-get install docker docker-compose; sudo usermod -aG docker $USER; break;;
            No ) if [ $i -ne 1 ];then
                        echo "docker could not be found please install it to continue"
                        exit -1
                    fi;;
            Exit ) exit 0;;
        esac
    done
fi

echo "Creating folder file"
sudo mkdir -p /data/blockchain/ntity-01

echo "Copy the configuration File"
sudo cp ./files/ntity.genesis.json /data/blockchain/
sudo cp ./files/static-nodes.json /data/blockchain/

echo "Build docker image"
echo "Choose platform"
select yn in "Server" "Raspberry-64" "Raspberry-32" "Exit"; do
    case $yn in
        Server ) sudo docker pull ntity/node:latest;version=latest;break;;
        Raspberry-64 ) sudo docker pull ntity/node:arm64v8;version=arm64v8;break;;
        Raspberry-32 ) sudo docker pull ntity/node:arm32v7;version=arm32v7;break;;
        Exit ) exit 0;;
    esac
done

echo "Wallet"
echo "If you don't have a keystore file you can generate at this stage a new wallet : "

select yn in "Create" "Existing" "Exit"; do
    case $yn in
        Create ) if [ $version = "latest" ]; then 
                
                    sudo docker run -it -v "/data/blockchain/ntity-01:/ethereum" ntity/node:latest geth --datadir=/ethereum --nousb account new 
                 fi;
                 if [ $version = "arm64v8" ]; then 
                
                    sudo docker run -it -v "/data/blockchain/ntity-01:/ethereum" ntity/node:arm64v8 geth --datadir=/ethereum --nousb account new 
                 fi;
                 if [ $version = "arm32v7" ]; then
                
                    sudo docker run -it -v "/data/blockchain/ntity-01:/ethereum" ntity/node:arm32v7 geth --datadir=/ethereum --nousb account new 
                 fi;
                 echo "Please copy your wallet for next part";break;;
        Existing ) sudo mkdir ./keystore/; echo "Please copy your keystore file into the local /node/keystore/ folder and press Enter";while [ true ] ; do
                                            read -s -N 1 -t 1 key
                                            if [[ $key == $'\x0a' ]]; then
                                                sudo cp -r ./keystore /data/blockchain/ntity-01/
                                                break;
                                            fi;done; break;;
        Exit ) exit 0;;
    esac
done

echo "Use password to unlock the wallet"
read -s pass
sudo mkdir /data/blockchain/password/
echo  "$pass" | sudo tee /data/blockchain/password/password.txt

echo "Please enter your wallet with the 0x"
read wallet
sed -i -e "s/0x57616c6c6574/$wallet/" ntity.yml
sed -i -e "s/latest/$version/" ntity.yml


echo "We initalize the miner"
sudo cp /data/blockchain/ntity.genesis.json /data/blockchain/ntity-01
if [ $version = "latest" ]; then

    sudo docker run -it -v "/data/blockchain/ntity-01:/blockchain" ntity/node:latest geth --datadir=/blockchain --nousb init /blockchain/ntity.genesis.json 
fi; 
if [ $version = "arm64v8" ]; then

    sudo docker run -it -v "/data/blockchain/ntity-01:/blockchain" ntity/node:arm64v8 geth --datadir=/blockchain --nousb init /blockchain/ntity.genesis.json 
fi; 
if [ $version = "arm32v7" ]; then 

    sudo docker run -it -v "/data/blockchain/ntity-01:/blockchain" ntity/node:arm32v7 geth --datadir=/blockchain --nousb init /blockchain/ntity.genesis.json 
fi; 

echo "Please choose a name to your miner"
read name
sed -i -e "s/nttMiner/$name/" ./files/app.json

echo "You are ready to start the miner"
echo "please type command : sudo docker-compose -f ntity.yml up"

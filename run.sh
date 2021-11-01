#!/bin/bash
if ! command -v git &> /dev/null;then
    echo "Do you wish to install git?"
    select yn in "Yes" "No" "Exit"; do
        case $yn in
            Yes ) sudo apt-get install git; break;;
            No ) if ! command -v git &> /dev/null;then
                    echo "git could not be found please install it to continue"
                    exit -1
                fi;;
            Exit ) exit 0;;
        esac
    done
fi

if ! command -v sudo docker &> /dev/null;then
    echo "Do you wish to install docker?"
    select yn in "Yes" "No" "Exit"; do
        case $yn in
            Yes ) sudo apt-get install docker docker-compose; sudo usermod -aG docker $USER; break;;
            No ) if ! command -v sudo docker &> /dev/null;then
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
        Server ) sudo docker pull ntity/blockchain:latest;version=latest;break;;
        Raspberry-64 ) sudo docker pull ntity/blockchain:arm64v8;version=arm64v8;break;;
        Raspberry-32 ) sudo docker pull ntity/blockchain:arm32v7;version=arm32v7;break;;
        Exit ) exit 0;;
    esac
done

echo "Wallet"
echo "To use existing one you need a file like this {'version':3,'id':'fc7d2 ... 7e035cfd805a'}}"

select yn in "Create" "Existing" "Exit"; do
    case $yn in
        Create ) if [ $version = "latest" ] then sudo docker run -it -v "/data/blockchain/ntity-01:/ethereum" ntity/blockchain:latest geth --datadir=/ethereum --nousb account new fi; 
                 if [ $version = "arm64v8" ] then sudo docker run -it -v "/data/blockchain/ntity-01:/ethereum" ntity/blockchain:arm64v8 geth --datadir=/ethereum --nousb account new fi;
                 if [ $version = "arm32v7" ] then sudo docker run -it -v "/data/blockchain/ntity-01:/ethereum" ntity/blockchain:arm32v7 geth --datadir=/ethereum --nousb account new fi;
                 echo "Please copy your wallet for next part";break;;
        Existing ) sudo mkdir ./keystore/; echo "Please copy the file into keystore and press Enter";while [ true ] ; do
                                            read -s -N 1 -t 1 key
                                            if [[ $key == $'\x0a' ]]; then
                                                sudo cp ./keystore /data/blockchain/ntity-01/
                                                break;
                                            fi;done; break;;
        Exit ) exit 0;;
    esac
done

echo "Use password to unlock the wallet"
read -sp pass
sudo mkdir /data/blockchain/password/
echo  $pass | sudo tee /data/blockchain/password/password.txt

echo "Please enter your wallet with the 0x"
read -p wallet
sed -i "s/[Wallet]/$wallet/" ./ntity.yml

echo "We initalize the miner"
sudo cp /data/blockchain/ntity.genesis.json /data/blockchain/ntity-01
if [ $version = "latest" ] then sudo docker run -it -v "/data/blockchain/ntity-01:/blockchain" ntity/blockchain:latest geth --datadir=/blockchain --nousb init /blockchain/ntity.genesis.json fi; 
if [ $version = "arm64v8" ] then sudo docker run -it -v "/data/blockchain/ntity-01:/blockchain" ntity/blockchain:arm64v8 geth --datadir=/blockchain --nousb init /blockchain/ntity.genesis.json fi; 
if [ $version = "arm32v7" ] then sudo docker run -it -v "/data/blockchain/ntity-01:/blockchain" ntity/blockchain:arm32v7 geth --datadir=/blockchain --nousb init /blockchain/ntity.genesis.json fi; 
sudo docker run -it -v "/data/blockchain/ntity-01:/blockchain" ntity/blockchain:$version geth --datadir=/blockchain --nousb init /blockchain/ntity.genesis.json

echo "Please choose a name to your miner"
read -p name
sed -i "s/[name]/$name/" ./files/app.json

echo "You are ready to start the miner"

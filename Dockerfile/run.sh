#!/bin/bash

# Available APIs eth,miner,net,web3,personal,txpool
echo -e "================  VARIABLES  ===================
      DATA_DIR=${DATA_DIR:="/ethereum/"}
      FREEZER_DIR=${FREEZER_DIR:="/ethereum/freezer"}
      AUTHORIZED_IP=${AUTHORIZED_IP:="0.0.0.0"}
      API_ALLOWED=${API_ALLOWED:="debug,net,eth,web3,txpool"}
      VERBOSITY=${VERBOSITY:=1}
      NETWORK=${NETWORK:=mainnet}
      GCMODE=${GCMODE:=archive}
      SYNCMODE=${SYNCMODE:=full}
      CACHE=${CACHE:=2048}
      DEV_MODE=${DEV_MODE:=false}"
echo "================================================="

if [ "x$DATA_DIR" == "x" ]; then
  echo "DATA_DIR is undefined !"
  echo "Exiting."
  exit -1;
fi

if [ ! -d $DATA_DIR ]; then
  mkdir $DATA_DIR
fi

if [ $DEV_MODE == true ]; then
  GETH_OPTS="$GETH_OPTS --dev "
fi

NODE_LOG="$DATA_DIR/node.log"

GETH_OPTS="$GETH_OPTS 
          --syncmode=$SYNCMODE --gcmode=$GCMODE
          --http --http.addr=$AUTHORIZED_IP --http.corsdomain '*' --http.api=$API_ALLOWED --http.vhosts=*
          --ws --ws.addr=$AUTHORIZED_IP --ws.api=$API_ALLOWED
          --nousb
          --datadir=$DATA_DIR --datadir.ancient=$FREEZER_DIR
          --networkid=$NETWORK_ID
          --verbosity=$VERBOSITY
          --unlock=$WALLET --miner.etherbase=$WALLET"

cd /root/ethstats-client/
pm2 start ./app.json

echo "geth $GETH_OPTS"

geth console --exec "admin.nodeInfo.enode" > $DATA_DIR/enode.txt

geth $GETH_OPTS 2>&1 >$NODE_LOG

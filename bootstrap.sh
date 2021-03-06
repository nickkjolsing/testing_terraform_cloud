#!/bin/bash

CHAIN_ID="bombay-12"
MONIKER="twinstake"

# setup the limits
# Increase maximum file descriptors
echo "*               soft    nofile          65535" >> /etc/security/limits.conf
echo "*               hard    nofile          65535" >> /etc/security/limits.conf

case "${CHAIN_ID}" in 
    "bombay-12")
	sudo cp terrad.service /etc/systemd/system/
	;;
    *)
	sudo cp terrad.service /etc/systemd/system/
	#sudo cp validator/*.service /etc/systemd/system/
	;;
esac

# additional stuff required on the box
sudo apt-get update && sudo apt-get upgrade -y
# libleveldb-dev is needed if we want to build terrad with cleveldb. should be harmless otherwise
sudo apt-get install -y build-essential git libleveldb-dev liblz4-tool net-tools
# GO .. as we're building it from source.
curl -LO https://go.dev/dl/go1.17.8.linux-amd64.tar.gz
#curl -LO https://golang.org/dl/go1.16.8.linux-amd64.tar.gz

tar xfz go1.17.8.linux-amd64.tar.gz
#tar xfz ./go1.16.8.linux-amd64.tar.gz

if [ -d "/usr/local/go" ]; 
then
    sudo rm -rf /usr/local/go
fi
sudo mv go /usr/local

# set up paths for next time
echo "export PATH=$PATH:$(go env GOPATH)/bin" >> /etc/profile
echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
source /etc/profile
mv validator/.bashrc ${HOME}
chmod 755 ${HOME}/.bashrc
export GOPATH=${HOME}/go
export PATH=${PATH}:/usr/local/go/bin:${PWD}/go/bin

# get the code

git clone https://github.com/terra-money/core/
cd core
case "${CHAIN_ID}" in 
    "bombay-12")
	git checkout v0.5.17
	;;
    *)
	git checkout v0.5.17
	;;
esac


#
# should this use cleveldb
# go build -tags cleveldb
make install
# terraD binaries are in the right place now
terrad init "${MONIKER}" --chain-id ${CHAIN_ID}
if [ -f ".terra/config/genesis.json" ];
then
    rm -f .terra/config/genesis.json 
fi 

case "${CHAIN_ID}" in 
    "columbus-5") 
        echo "Columbus-5 not supported yet"
	# TBD
#        curl https://columbus-genesis.s3-ap-northeast-1.amazonaws.com/genesis.json > $HOME/.terrad/config/genesis.json
#        curl https://network.terra.dev/addrbook.json > $HOME/.terrad/config/addrbook.json
        # TBD is address.json actually needed?

        ;;
    "bombay-12")
#        curl https://raw.githubusercontent.com/terra-project/testnet/master/bombay-9/genesis.json > $HOME/.terra/config/genesis.json
	curl https://raw.githubusercontent.com/terra-money/testnet/master/bombay-12/genesis.json > $HOME/.terra/config/genesis.json
	curl https://raw.githubusercontent.com/terra-money/testnet/master/bombay-12/addrbook.json > $HOME/.terra/config/addrbook.json
	;;
    *)
        echo "${CHAIN_ID} not known"
        exit 1
    ;;
esac 
case "${CHAIN_ID}" in 
    "bombay-12")
	pushd ${HOME}/.terra
	;;
    *)
	pushd ${HOME}/.terra
	;;
esac


#pushd ${HOME}
cp ./config/config.toml ./config/config.toml.orig
# sed script to fix indexer line to 'null'
# sed 's/indexer = \"kv\"/indexer = \"null\"/' < .terrad/config/config.toml.orig > .terrad/config/config.toml.1 
sed 's/\"data/\"\/root\/.terra\/data/' < ./config/config.toml.orig > ./config/config.toml.1
case "${CHAIN_ID}" in 
    "columbus-5") 
        echo "Columbia not supported yet"
        sed 's/seeds = \"\"/seeds = \"20271e0591a7204d72280b87fdaa854f50c55e7e@106.10.59.48:26656,3b1c85b86528d10acc5475cb2c874714a69fde1e@110.234.23.153:26656,49333a4cb195d570ea244dab675a38abf97011d2@13.113.103.57:26656,7f19128de85ced9b62c3947fd2c2db2064462533@52.68.3.126:26656,87048bf71526fb92d73733ba3ddb79b7a83ca11e@13.124.78.245:26656\"/' < ./config/config.toml.1 > ./config/config.toml
        ;;
    "bombay-12")
        sed 's/seeds = \"\"/seeds = \"e14dcea40de9b7cc31ea3e843c25bcdd8d91c36d@solarsys.noip.me:38656,7261b247dc05b8f8aca7a74529e5caf9c51d5379@162.55.132.48:15635,347e81ce9380e10b2c9838eb92a4f35b1ff5eb7a@162.55.131.238:15635,2b7150ff60df7b8bc1aa50ab586c18c7d9550171@3.130.148.2:26656\"/' < ./config/config.toml.1 > ./config/config.toml
        ;;
    *)
        echo "${CHAIN_ID} not known"
        exit 1
    ;;  
esac

# app.toml
cp ./config/app.toml ./config/app.toml.orig
sed 's/minimum-gas-prices = \"\"/minimum-gas-prices=\"0.01133uluna,0.104938usdr,0.15uusd,169.77ukrw,428.571umnt,0.125ueur,0.98ucny,16.37ujpy,0.11ugbp,10.88uinr,0.19ucad,0.14uchf,0.19uaud,0.2usgd,4.62uthb,1.25usek,1.25unok,0.9udkk,2180.0uidr,7.6uphp,1.17uhkd,0.6umyr,4.0utwd\"/' < ./config/app.toml.orig > ./config/app.toml


popd

# everything is in place ..
# lighting up daemons
sudo systemctl daemon-reload
sudo systemctl enable terrad.service 

echo "Running Terra service..."
sudo systemctl start terrad.service


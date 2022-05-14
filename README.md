## TRM, Lolminer, T-Rex, miners with EthMan-compatible API (Phoenix miner, Nanominer, Claymore's, etc.) monitoring based on Prometheus and Grafana
![](screenshot.png)
### TL;DR
I can help with setting it up for a small sum. Message me on Telegram: `@nouveau_nvc0`.
### Deploying
Run miners with following params:

- Teamredminer: `--api_listen=0.0.0.0:4028`
- Lolminer: `--apiport 4069`
- T-Rex: `--api-read-only --api-bind-http 0.0.0.0:4067` (in case you have set a password for T-Rex, pass it as the third parameter in the `RIGS` variable)
- Claymore's ETH, Phoenix and Nanominer listen on `3333` port by default. For other miners EthMan-compatible API check the documentation
- NVMiner (https://github.com/mhssamadani/Autolykos2_NV_Miner) listens on port `36207` by default

#### Configuring
You must declare `RIGS` environment variable:
```
RIGS='rig1=( trm 192.168.1.123 4028 )
rig2=( t-rex 192.168.1.123 4067 )
rig3=( t-rex 192.168.1.123 4067 yourApiPassword )
rig4=( lolminer 192.168.1.123 4069 )
rig5=( ethman 192.168.1.123 3333 )
rig6=( nvminer 192.168.1.123 36207 )'
```

#### Without Telegram alerts
```
docker-compose -f docker-compose.yml up --build
```

#### With Telegram alerts
Create Telegram bot (message `@botfather`) and get your user ID (message `@userinfobot`). For details: https://github.com/metalmatze/alertmanager-bot/blob/0.4.2/README.md
```
cp alertmanager-bot.sh.example alertmanager-bot.sh
```
Then open `alertmanager-bot.sh` and configure it.
```
docker-compose -f docker-compose-alertmanager-bot.yml up --build
```

Finally open `http://<server address>:3000/` in your browser.
After login to Grafana you should import json dashboards from `dashboards` dir.

#### If you want to buy me a coffee
BTC: `bc1qtv30ctkad9h2gnupx9pa59cgvpatswx5z90phc`

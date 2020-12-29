## TRM, Lolminer, T-Rex mining monitoring based on Prometheus and Grafana
![](screenshot.png)
### TL;DR
I can help with the setup inexpensively. Write me in Telegram: `@nouveau_nvc0`.
### Deploying
Run miners with following params:

- Teamredminer: `--api_listen=0.0.0.0:4028`
- Lolminer: `--apiport 4069`
- T-Rex: `--api-bind-http 0.0.0.0:4067`

#### Warning
If your local subnet is other than 192.168.1.1/24 you must change it in the top of the `mining-exporter/server.sh` file 

#### Without Telegram alerts
```
docker-compose -f docker-compose.yml up --build
```

#### With Telegram alerts
Create Telegram bot (write `@botfather`) and get your user ID (write `@userinfobot`). For details: https://github.com/metalmatze/alertmanager-bot
```
cp alertmanager-bot.sh.example alertmanager-bot.sh
```
Then open `alertmanager-bot.sh` and configure it.
```
docker-compose -f docker-compose-alertmanager-bot.yml up --build
```


Finally open `http://<server address>:3000/` in your browser.
After login to Grafana you should import json dashboards from `dashboards` dir.

#### TODO
- add XMPP/Telegram alerts via Prometheus Alertmanager

#### If you want to buy me a coffee
BTC: `bc1qtv30ctkad9h2gnupx9pa59cgvpatswx5z90phc`

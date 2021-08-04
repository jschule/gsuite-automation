# G Suite Automation for our School
Automating the administration of our G Suite domain

Expects 

* https://github.com/taers232c/GAMADV-XTD3 in `~/bin/gamadv-xtd3/gam`
* `domain` set to your domain in `~/.gam/gam.cfg`
* `config.sh` with
  * `MASTERSHEET` is the G Sheet ID for master data
  * `MASTERUSER` is the G Domain User to access the master data sheet

## Tricks

* [Transfer Google Drive](https://github.com/taers232c/GAMADV-XTD3/wiki/Google-Data-Transfers) to other user:

  ```bash
  gam create transfer OLD_USERNAME drive OLD_USERNAME all
  ```



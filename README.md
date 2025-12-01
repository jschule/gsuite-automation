# G Suite Automation for our School
Automating the administration of our G Suite domain

Expects 

* https://github.com/taers232c/GAMADV-XTD3 in `~/bin/gamadv-xtd3/gam`
* `domain` set to your domain in `~/.gam/gam.cfg`
* `config.sh` with
  * `MASTERSHEET` is the G Sheet ID for master data
  * `MASTERUSER` is the G Domain User to access the master data sheet
  * `STARTPASSWORD` is the start password used for employee accounts
  * `DELETE_OU` is the OU where users to delete will be moved to
  * `NOTIFICATIONUSER` is the user who receives the email for new employees
  * `STUDENT_PARENTS_GROUP_MANAGERS` is a list of users who will be managers for the student or parent groups
  * `DATA_TRANSFER_RECIPIENT` is the default new owner for course reassignments or data transfers (deleting employees)
  * `KITA` is the domain of the Kita

## Tricks

* [Transfer Google Drive](https://github.com/taers232c/GAMADV-XTD3/wiki/Google-Data-Transfers) to other user:

  ```bash
  gam create transfer OLD_USERNAME drive NEW_USERNAME all
  ```



#!/bin/sh -ex
PRODUCT_NAME=Ahblog
BACKUP_DIR=/opt/keter/backup

if [ ! -d $BACKUP_DIR ]; then
  sudo mkdir ${BACKUP_DIR}
  sudo chown ${USER}:${USER} ${BACKUP_DIR}
fi
if [ ! -d $BACKUP_DIR/files ]; then
  sudo mkdir ${BACKUP_DIR}/files
fi

cp /opt/keter/temp/${PRODUCT_NAME}-*/*_production.sqlite3 ${BACKUP_DIR}
cp /opt/keter/temp/${PRODUCT_NAME}-*/static/files/* ${BACKUP_DIR}/files/

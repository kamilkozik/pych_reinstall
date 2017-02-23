#! /bin/bash

PYCHARM_URL=`awk -F\; '{if ( $1 == "pycharm" ) print $2}' < $HOME/usr/pycharm_settings/app-urls.txt`
PYCHARM_SAVED_SETTINGS_DIR=$HOME/usr/pycharm_settings/config
DEST_DIR=$HOME/bin
echo "Clean dir..."
rm -rf $DEST_DIR/pycharm-*
rm -rf $DEST_DIR/pycharm
rm -rf $HOME/.PyCharm*

echo "Fetching pycharm..."
wget $PYCHARM_URL

ZIP_FILE_NAME="${PYCHARM_URL#https://download.jetbrains.com/python/}"
tar -xzvf $ZIP_FILE_NAME -C $DEST_DIR
rm $ZIP_FILE_NAME

FILE_NAME_PREFIX=`ls ${DEST_DIR} | grep pycharm-`
FILE_NAME_HASH=`cat /dev/urandom | tr -cd 'a-zA-Z0-9\-_' | head -c 32`

echo $FILE_NAME_PREFIX

SETTINGS_FILE_NAME=${FILE_NAME_PREFIX#pycharm-}
SETTINGS_FILE_NAME_1=${SETTINGS_FILE_NAME%.3}
SETTINGS_FILE_NAME_2=.PyCharm${SETTINGS_FILE_NAME_1}
PYCHARM_SETTINGS_DIR=${HOME}/${SETTINGS_FILE_NAME_2}/config

FILE_NAME=${FILE_NAME_PREFIX}-${FILE_NAME_HASH}


mv $DEST_DIR/$FILE_NAME_PREFIX $DEST_DIR/$FILE_NAME
ln -s $DEST_DIR/$FILE_NAME/bin/pycharm.sh $DEST_DIR/pycharm
mkdir -p .pycharm2016.3/options/ .pycharm2016.3/plugins/ .pycharm2016.3/codestyles/
cp -r ${PYCHARM_SAVED_SETTINGS_DIR}/options/ ${PYCHARM_SAVED_SETTINGS_DIR}/plugins/ ${PYCHARM_SAVED_SETTINGS_DIR}/codestyles/ .pycharm2016.3


cat << EOF > $HOME/.gnome/apps/jetbrains-pycharm.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=PyCharm
Icon=${DEST_DIR}/${FILE_NAME}/bin/pycharm.png
Exec="${DEST_DIR}/${FILE_NAME}/bin/pycharm.sh" %f
Comment=The Drive to Develop
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-pycharm
OnlyShowIn=Old;
EOF
#! /usr/bin/env sh

if ! [ $(id -u) = 0 ]; then
   echo "The script needs to be root to restart apache." >&2
   echo "Please try again with sudo!" >&2
   exit 1
fi

#php --ini | head -1 | sed -e '1,/Path: /d'
INIPATH="`php --ini | head -1 | sed -n -e 's/^.*Path: \(\)/\1/p'`/conf.d"
XDEBUGFILES=`find $INIPATH -type f -regex '.*xdebug.*'`
for FILE in $XDEBUGFILES; do
    if [ ${FILE: -4} == ".ini" ]
    then
        echo "Disabling XDEBUG"
        echo "Moving file: mv \"${FILE}\" \"${FILE}.bu\""
        mv "${FILE}" "${FILE}.bu"
    else
        NEWNAME=${FILE::${#FILE}-3}
        echo "Enabling XDEBUG"
        echo "Moving file: mv \"${FILE}\" \"${NEWNAME}\""
        mv "${FILE}" "${NEWNAME}"
    fi
done
echo "Restarting Apache."
apachectl restart

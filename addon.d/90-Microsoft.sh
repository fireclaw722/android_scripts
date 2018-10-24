#!/sbin/sh
#
# ADDOND_VERSION=2
#
# /system/addon.d/90-ExtraPrivApps.sh
#
. /tmp/backuptool.functions

list_files() {
cat <<EOF
priv-app/MicrosoftLauncher/MicrosoftLauncher.apk
app/Bing/Bing.apk
app/Cortana/Cortana.apk
addon.d/90-Microsoft.sh
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/$FILE
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/$FILE $R
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    if [ -d "/postinstall" ]; then
      P="/postinstall/system"
    else
      P="/system"
    fi

    for i in $(list_files); do
      chown root:root "$P/$i"
      chmod 644 "$P/$i"
      chmod 755 "$(dirname "$P/$i")"
    done
  ;;
esac

#!/usr/bin/env bash

PICTURE_DIR="$HOME/Pictures/bing_wallpapers/"

mkdir -p $PICTURE_DIR

urls=( $(curl -L http://cn.bing.com | \
  grep -Eo "g_img={url:'.*?'" | \
  sed -e "s/g_img={url:'\([^']*\)'.*/\1/" | \
  sed -e "s/\\\//g") )

for p in ${urls[@]}; do
  wallpaper_location=$p
  if [[ $p != *"cn.bing"* ]] 
  then
    bing_prefix="cn.bing.com"
    wallpaper_location=$bing_prefix$p
  fi
  echo $wallpaper_location
  filename=$(echo $wallpaper_location|sed -e "s/.*\/\(.*\)/\1/")
  if [ ! -f $PICTURE_DIR/$filename ]; then
      echo "Downloading: $filename ..."
      curl -Lo "$PICTURE_DIR/$filename" $wallpaper_location
  else
      echo "Skipping: $filename ..."
  fi
done

PID=$(pgrep gnome-session)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)

sleep 5
gsettings set org.gnome.desktop.background picture-uri file://$PICTURE_DIR/$filename


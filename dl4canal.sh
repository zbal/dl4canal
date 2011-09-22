#!/bin/bash
#############################################
# dl4canal is a script to fetch RTMP streams from Canal+ (French TV)
#############################################
# Contact:
#  vincent.viallet@gmail.com
#############################################

LOCK="/tmp/$(basename $0).lock"

# Avoid multiple running scripts
if [ -e $LOCK ]; then
  OLD_PID=$(cat $LOCK)
  if [ -d /proc/$OLD_PID ]; then 
    echo "$0 already running - pid: $(cat $LOCK)"
    exit 1
  else
    echo $$ > $LOCK
  fi
else
  echo $$ > $LOCK
fi

# That's really ugly...
dumpvids() {
  emission_latest_vids=$1
  emission_folder=$BASE/$(echo $emission_latest_vids | cut -f1 -d'|')
  emission_url=$(echo $emission_latest_vids | cut -f2- -d'|')

  [ ! -d "$emission_folder" ] && mkdir -p "$emission_folder"
  cd "$emission_folder"
  
  wget $emission_url -O $(basename $emission_url)
  
  # Get latest video ID to gather XML file
  latest_video_id=$(grep switchVideoPlayer $(basename $emission_url) | head -1  | cut -f2 -d'(' | cut -f1 -d')')
  
  source_wget="http://service.canal-plus.com/video/rest/getVideosLiees/cplus/$latest_video_id"
  output_wget=$(basename $source_wget)
  wget $source_wget -O $output_wget
  
  # get videos from file - ugly XML parsing...
  videos_hd=$(sed -e 's/</\n</g' $output_wget | grep HAUT_DEBIT | sed -e 's/rtmp/\nrtmp/g' | grep rtmp)
  
  for video_hd in $videos_hd
  do
    video_name=$(basename $video_hd)
    if [ ! -f "$video_name" ]; then
      $RTMPDUMP_BIN -r $video_hd -o $video_name
    fi
  done
}

# Process all emissions defined in configuration file
source $(basename $0).conf
for emission in "${EMISSION[@]}"
do
  dumpvids $emission
done

rm $LOCK

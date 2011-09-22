#!/bin/bash
###########################################33
#
# Ugly but .. working
#
#############################################

RTMPDUMP_BIN='/opt/media/tech/svn/utils/rtmpdump/rtmpdump'

cd /opt/media/video
mkdir -p canal/guignols
cd canal/guignols

# Guignols -- latest videos from website
source_url_latest_vids='http://www.canalplus.fr/c-divertissement/pid1784-les-guignols-de-l-info.html'
wget $source_url_latest_vids -O $(basename $source_url_latest_vids)

# Get latest video ID to gather XML file
latest_video_id=$(grep switchVideoPlayer $(basename $source_url_latest_vids) | head -1  | cut -f2 -d'(' | cut -f1 -d')')
latest_video_id=380224

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

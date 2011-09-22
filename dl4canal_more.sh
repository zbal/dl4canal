#!/bin/bash
###########################################33
#
# Ugly but .. working
#
#############################################

LOCK="/tmp/$(basename $0).lock"

# avoid multiple running scripts
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

RTMPDUMP_BIN='/opt/media/tech/svn/utils/rtmpdump/rtmpdump'


URL_GUIGNOLS='http://www.canalplus.fr/c-divertissement/pid1784-les-guignols-de-l-info.html'
URL_GROLAND='http://www.canalplus.fr/c-humour/pid1787-c-groland.html'
URL_PETIT_JOURNAL='http://www.canalplus.fr/c-humour/pid2397-c-le-petit-journal.html'
URL_PEPITE_DU_NET='http://www.canalplus.fr/c-humour/pid1778-c-pepites-sur-le-net.html'
URL_ACTION_DISCRETE='http://www.canalplus.fr/c-divertissement/pid1780-action-discrete.html'
URL_ZAPPING='http://www.canalplus.fr/c-infos-documentaires/pid1830-zapping.html'

BASE=/opt/media/video/canal

cd $BASE
mkdir -p guignols groland petit_journal pepite_du_net action_discrete zapping

dumpvids() {
  source_url_latest_vids=$1
  wget $source_url_latest_vids -O $(basename $source_url_latest_vids)
  
  # Get latest video ID to gather XML file
  latest_video_id=$(grep switchVideoPlayer $(basename $source_url_latest_vids) | head -1  | cut -f2 -d'(' | cut -f1 -d')')
  
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

cd $BASE/guignols
  dumpvids $URL_GUIGNOLS

cd $BASE/groland
  dumpvids $URL_GROLAND

cd $BASE/petit_journal
  dumpvids $URL_PETIT_JOURNAL

cd $BASE/pepite_du_net
  dumpvids $URL_PEPITE_DU_NET

cd $BASE/action_discrete
  dumpvids $URL_ACTION_DISCRETE

cd $BASE/zapping
  dumpvids $URL_ZAPPING

rm $LOCK

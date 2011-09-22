# Purpose
dl4canal is a simple collection of shell scripts used to retrieve streaming videos from French video channel [Canal+](http://canalplus.fr).

# Why
Several reasons to that **why** question:

- Some want to keep old videos to watch them sometime later (most of those videos are unavailable after a week)
- Some have such a poor internet connection that watching the videos in streaming on the official website is almost impossible

# Requirements
Need to get and compile [RTMPDump](http://rtmpdump.mplayerhq.hu/) - awesome library from Andrej Stepanchuk / Howard Chu.

<pre>
git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump
make
</pre>

# Usage
To complete - meanwhile, read the script for more details.

- Get the script (dl4canal_more.sh)
- Browse the Canal+ website, select your shows and grab the direct URL
- Edit the script (will be fixed later with a proper configuration file) and add the URL of your shows
- Edit script and fix working dir and paths
- Run the script...

Of course you can automate the retrieval of the video via cronjob, so you won't ever miss any of them!
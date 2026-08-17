#!/bin/bash

KICK_URL="https://kick.com/id7o"
RESTREAM_KEY="re_11725544_event1f24e3174647428d86fc1329252bbf36"
RTMP_URL="rtmp://live.restream.io/live/$RESTREAM_KEY"

echo "جاري سحب البث من Kick ومعالجة الصوت لأعلى مستوى..."

streamlink --stdout "$KICK_URL" best | ffmpeg -i pipe:0 \
    -af "loudnorm=I=-16:TP=-1.5:LRA=11,volume=2.0" \
    -c:v copy \
    -c:a aac -b:a 192k -ar 44100 \
    -f flv "$RTMP_URL"

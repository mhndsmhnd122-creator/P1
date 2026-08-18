#!/bin/bash

KICK_URL="https://kick.com/Seagull"
RESTREAM_KEY="re_11725544_event1f24e3174647428d86fc1329252bbf36"
RTMP_URL="rtmp://live.restream.io/live/$RESTREAM_KEY"

# إضافة --http-header لتجاوز الحماية
streamlink --http-header "User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
    --stdout "$KICK_URL" best | ffmpeg -i pipe:0 \
    -af "loudnorm=I=-16:TP=-1.5:LRA=11,volume=2.0" \
    -c:v copy \
    -c:a aac -b:a 192k -ar 44100 \
    -f flv \
    -rtmp_live live \
    "$RTMP_URL"

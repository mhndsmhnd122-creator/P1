#!/bin/bash

# تم تغيير الرابط لقناة OSAMAH
KICK_URL="https://kick.com/OSAMAH"
RESTREAM_KEY="re_11725544_event1f24e3174647428d86fc1329252bbf36"
RTMP_URL="rtmp://live.restream.io/live/$RESTREAM_KEY"

echo "جاري سحب البث من قناة OSAMAH ومعالجة الصوت بثبات تام..."

streamlink --stdout "$KICK_URL" best | ffmpeg -i pipe:0 \
    -af "loudnorm=I=-16:TP=-1.5:LRA=11,volume=2.0" \
    -c:v copy \
    -c:a aac -b:a 192k -ar 44100 \
    -f flv \
    -rtmp_live live \
    -reconnect_at_eof 1 \
    -reconnect_streamed 1 \
    -reconnect_delay_max 5 \
    "$RTMP_URL"

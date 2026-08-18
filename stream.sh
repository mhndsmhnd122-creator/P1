#!/bin/bash

KICK_URL="https://kick.com/OSAMAH"
RESTREAM_KEY="re_11725544_event1f24e3174647428d86fc1329252bbf36"
RTMP_URL="rtmp://live.restream.io/live/$RESTREAM_KEY"

echo "جاري فرض سحب البث المباشر فوراً..."

# استخدام streamlink بوضع الاتصال المباشر مع تجاوز أخطاء الفحص
while true; do
    streamlink --stdout "$KICK_URL" best 2>/dev/null | ffmpeg -re -i pipe:0 \
        -af "loudnorm=I=-16:TP=-1.5:LRA=11,volume=2.0" \
        -c:v copy \
        -c:a aac -b:a 192k -ar 44100 \
        -f flv \
        -rtmp_live live \
        -reconnect_at_eof 1 \
        -reconnect_streamed 1 \
        -reconnect_delay_max 5 \
        "$RTMP_URL"
    
    echo "انقطع البث مؤقتاً، إعادة محاولة الاتصال خلال 5 ثوانٍ..."
    sleep 5
done

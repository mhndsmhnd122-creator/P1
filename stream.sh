#!/bin/bash

KICK_URL="https://kick.com/seagull"
RESTREAM_KEY="rtmp://live.restream.io/live/5vbt-bykh-44hv-zq7g-31mb"

while true; do
    echo "جاري التحقق من حالة البث على قناة كيك..."
    
    # محاولة فحص الرابط وسحب البث عبر streamlink
    if streamlink --http-header "User-Agent=Mozilla/5.0" "$KICK_URL" best > /dev/null 2>&1; then
        echo "البث شغال الآن! جاري بدء إعادة التوجيه..."
        
        # تشغيل البث لمدة 5 ساعات ونصف (19800 ثانية) ثم إعادة الفحص
        timeout 19800s streamlink --http-header "User-Agent=Mozilla/5.0" "$KICK_URL" best --stdout | \
        ffmpeg -i pipe:0 \
        -c:v copy \
        -c:a aac -b:a 192k -ar 44100 \
        -f flv \
        "$RESTREAM_KEY"
        
        echo "انتهت فترة الـ 5 ساعات ونصف، جاري إعادة التشغيل لتحديث الاتصال..."
    else
        echo "القناة لا تبث حالياً. جاري إعادة الفحص خلال 10 ثوانٍ..."
        sleep 10
    fi
done

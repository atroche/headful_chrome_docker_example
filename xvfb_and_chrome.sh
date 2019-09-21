#!/usr/bin/bash
set -e

Xvfb :99 &
XVFB_PID=$!

ffmpeg -r 30 -f x11grab -i :99 -draw_mouse 0 -s 1280x800 -c:v libvpx -quality realtime -cpu-used 0 -b:v 384k -qmin 10 -qmax 42 -maxrate 384k -bufsize 1000k -an /screen.webm &
FFMPEG_PID=$!

chromium-browser --remote-debugging-port=8917 --no-sandbox \
                 --enable-logging --verbose --log-level=0 \
                 "https://google.com" &
CHROME_PID=$!

sleep 5

echo "done initial sleep, trying to kill now."

while kill $CHROME_PID; do
    sleep 1
done

while kill $FFMPEG_PID; do
    sleep 1
done

while kill $XVFB_PID; do
    sleep 1
done

ls /screen.webm
ps -aux
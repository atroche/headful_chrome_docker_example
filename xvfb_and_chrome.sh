#!/usr/bin/bash
set -e

# This script does different things based on whether it's being run on Cloud Run.
# On local we record with ffmpeg to demonstrate that things work fine. On Cloud Run we just try to start Xvfb and Chrome.

# (should not be set locally)
if [[ -v K_SERVICE ]]; then

echo "Running on Cloud Run"

Xvfb :99 &

# note that the DISPLAY env var is set to 99 in the Dockerfile
chromium-browser --remote-debugging-port=8917 --no-sandbox \
                 --enable-logging --verbose --log-level=0 \
                 "https://google.com"

else

echo "Running in local docker container, with ffmpeg to show that recording works"

Xvfb :99 &
XVFB_PID=$!

ffmpeg -y -r 30 -f x11grab -i :99 -draw_mouse 0 -s 1280x800 -c:v libvpx -quality realtime -cpu-used 0 -b:v 384k -qmin 10 -qmax 42 -maxrate 384k -bufsize 1000k -an /output/screen.webm &
FFMPEG_PID=$!

chromium-browser --remote-debugging-port=8917 --no-sandbox --window-size=1280x800 \
                 --enable-logging --verbose --log-level=0 \
                 "https://google.com" &
CHROME_PID=$!

sleep 5

echo "done initial sleep, trying to kill now."

while kill $CHROME_PID &> /dev/null; do
    sleep 1
done

while kill $FFMPEG_PID &> /dev/null; do
    sleep 1
done

while kill $XVFB_PID &> /dev/null; do
    sleep 1
done

ls /output/screen.webm

fi

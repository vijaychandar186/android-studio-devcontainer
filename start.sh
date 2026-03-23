#!/bin/bash
sudo chmod 777 /dev/kvm 2>/dev/null || true
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:/opt/android-studio/bin

# Clean up stale X lock and VNC
vncserver -kill :1 >/dev/null 2>&1 || true
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

# Start VNC
vncserver :1 -geometry 1280x800 -depth 24
export DISPLAY=:1

# Wait until X display is actually ready
for i in $(seq 1 20); do
    xdpyinfo -display :1 >/dev/null 2>&1 && break
    sleep 1
done

# Start noVNC
websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

# Launch Android Studio in background so this script exits cleanly
nohup /opt/android-studio/bin/studio.sh >/tmp/studio.log 2>&1 &

exit 0

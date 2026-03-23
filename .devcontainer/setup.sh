#!/bin/bash

ANDROID_STUDIO_VERSION="2024.2.1.11"

echo ">>> Installing dependencies..."
sudo apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    openjdk-17-jdk wget unzip \
    tightvncserver novnc websockify openbox xterm \
    libgl1-mesa-glx libpulse0 libxtst6 libxi6 lib32z1 \
    x11-utils
sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

echo ">>> Fixing /dev/kvm permissions..."
sudo chmod 777 /dev/kvm 2>/dev/null || true

echo ">>> Downloading Android Studio ${ANDROID_STUDIO_VERSION}..."
wget -q "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${ANDROID_STUDIO_VERSION}/android-studio-${ANDROID_STUDIO_VERSION}-linux.tar.gz" -O /tmp/as.tar.gz
sudo tar -xzf /tmp/as.tar.gz -C /opt/
rm /tmp/as.tar.gz

echo ">>> Downloading Android SDK command-line tools..."
wget -q "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" -O /tmp/cmdline-tools.zip
mkdir -p $HOME/Android/Sdk/cmdline-tools
unzip -q /tmp/cmdline-tools.zip -d /tmp/clt
mv /tmp/clt/cmdline-tools $HOME/Android/Sdk/cmdline-tools/latest
rm -rf /tmp/cmdline-tools.zip /tmp/clt

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator

echo ">>> Installing SDK packages..."
yes | sdkmanager --licenses > /dev/null 2>&1 || true
sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0"
# Note: emulator + system images are large — install from Android Studio's Device Manager instead

echo ">>> Setting up environment..."
cat >> $HOME/.bashrc << 'EOF'
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:/opt/android-studio/bin
EOF

echo ">>> Setting up VNC..."
mkdir -p $HOME/.vnc $HOME/.config/openbox
echo "password" | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd
printf '#!/bin/sh\nopenbox-session &\n' > $HOME/.vnc/xstartup
chmod +x $HOME/.vnc/xstartup

echo ">>> Done!"

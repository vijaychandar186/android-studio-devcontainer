# Android Studio on GitHub Codespaces

Run Android Studio in your browser using GitHub Codespaces — no local install, no VT-x required.

## What's included

- Android Studio Ladybug (2024.2.1.11)
- Java 17
- Android SDK (API 35, build-tools 35.0.0, platform-tools)
- VNC + noVNC (access via browser on port 6080)
- KVM hardware acceleration for the Android emulator

## First-time setup

1. Open this repo in GitHub Codespaces
2. Wait ~10 minutes for setup to complete (installs Android Studio + SDK automatically)
3. Once the terminal is available, run:

```bash
bash .devcontainer/start.sh
```

4. When prompted, open port **6080** in your browser
5. Android Studio will launch in the browser window

## Every time you reopen the Codespace

Run the same command in the terminal:

```bash
bash .devcontainer/start.sh
```

## Setting up the Android Emulator

The emulator system image is not pre-installed to save disk space. Install it from inside Android Studio:

1. Open **Device Manager** (right sidebar or Tools menu)
2. Click **Create Device**
3. Choose a device (e.g. Pixel 6)
4. Select a **x86_64** system image for API 35 and download it (~1GB)
5. Finish and click the play button to launch the emulator

The emulator runs with full KVM hardware acceleration — no slowness.

## VNC password

```
password
```

## Troubleshooting

**502 error on port 6080** — `start.sh` hasn't been run yet. Run it from the terminal.

**Android Studio logs** — check `/tmp/studio.log`

**noVNC logs** — check `/tmp/novnc.log`

**Emulator won't start** — make sure you selected an x86_64 system image, not ARM64.

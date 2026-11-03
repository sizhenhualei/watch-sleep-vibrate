# NDZ — NoDoze for Wear OS

**NDZ** (short for **NoDoze**) watches for long stillness and vibrates to wake you. The Chinese in-app title is **别睡**.

## NDZ 2.1 — five monitoring modes, configurable confirmation

| Mode | Strategy | Approx. time to alarm (default 20 s confirmation) |
|---|---|---|
| **Eco** | Event-driven: orientation + wrist-tilt; exact alarm at `lastMovement + threshold` | user threshold + 20 s |
| **One minute** | 60 s sampling | ~80 s |
| **Low power** | 30 s sampling | ~50 s |
| **High frequency** | 15 s sampling | ~35 s |
| **Continuous** | continuous accelerometer | ~20 s |

If the watch moves during the confirmation window, the alarm is cancelled and detection resumes.

### UI behavior

- Numeric settings, tuned for a round 450×450 Wear OS screen
- Eco threshold **1–999 s**, default **180 s** (only Eco shows this field)
- Confirmation window **1–60 s**, default **20 s** — shared by every mode
- Vibration strength **1–255**, default **255**
- Vibration interval **1–30 s**, default **3 s**
- Each pulse is **800 ms**
- No save button — edits auto-save (600 ms debounce) and hot-restart the running monitor
- Start button changes to **已开启** and disables; stop returns to **开启监测** and shows **已关闭** without leaving the screen

## Downloads

- `releases/NDZ-2.1.apk` — unified five-mode edition, versionCode 13 / versionName 2.1
- `releases/NDZ-2.1-OPFix.apk` — OPPO compatibility build, versionCode 14 / versionName 2.1-opfix
- `releases/NDZ-2.0.apk` — historical 2.0 release
- `releases/NDZ-1.0.apk` / `NDZ-1.0-Eco.apk` — historical 1.0 editions
- Icon: `assets/NDZ-icon-1024.png`

All editions use package `com.example.vibrate5s` and cannot be installed side by side.

```bash
adb install -r -d -g releases/NDZ-2.1.apk
# OPPO compatibility build:
adb install -r -d -g releases/NDZ-2.1-OPFix.apk
```

## OPPO OPFix

`NDZ-2.1-OPFix.apk` forces Eco to use an accelerometer fallback instead of the Wear OS-only orientation / wrist-tilt sensors. It is intended for OPPO Watch 3 Pro and other non-Wear-OS or sensor-limited watches.

**Important:** OPPO Watch 3 Pro runs ColorOS Watch rather than Wear OS. Compatibility depends on whether the watch accepts standard Wear OS APKs at all; this build has not been verified on OPPO hardware. If the APK cannot be installed by the watch, no APK-side fix can change that.

## Share-site mirror

- Video (compressed 960×540): `https://pan.1314514.xyz/file.php?hash=a20927267cff862758c32e04ed51c35a`
- Direct: `https://pan.1314514.xyz/down.php/a20927267cff862758c32e04ed51c35a.mp4`

APK mirrors are uploaded to the same share site alongside each GitHub release.

## Build

- `v2/` — NDZ 2.1 Java source, resources and `tools/build.ps1`
- `standard/`, `eco/` — historical 1.0 sources

The APKs in `releases/` are signed with the development keystore and are intended for sideloading, not Play Store distribution.

## Disclaimer

This is stillness detection, **not medical-grade sleep monitoring** and not a diagnosis tool. Do not rely on it for medical or safety-critical alerts.

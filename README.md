# NDZ — NoDoze for Wear OS

**NDZ** (short for **NoDoze**) watches for long stillness and vibrates to wake you. The Chinese in-app title is **别睡**.

## NDZ 2.0 — five monitoring modes in one app

| Mode | Strategy | Approx. time to alarm |
|---|---|---|
| **Eco** | Event-driven: orientation + wrist-tilt; exact alarm at `lastMovement + threshold` | user-set threshold + 30 s confirmation |
| **One minute** | 60 s sampling | ~90 s |
| **Low power** | 30 s sampling | ~60 s |
| **High frequency** | 15 s sampling | ~45 s |
| **Continuous** | continuous accelerometer | ~30 s |

The four fixed modes use the same 30-second confirmation window: if the watch moves during confirmation, the alarm is cancelled and detection resumes. Eco is the most battery-friendly; Continuous is the most sensitive.

### UI behavior

- Numeric settings, tuned for a round 450×450 Wear OS screen
- Threshold **1–999 s**, default **180 s**
- Vibration strength **1–255**, default **255**
- Vibration interval **1–30 s**, default **3 s**
- Each pulse is **800 ms**
- **Only Eco shows the threshold field**; fixed modes show their own strategy hint
- No save button — edits auto-save (600 ms debounce) and hot-restart the running monitor
- Start button changes to **已开启** and disables; stop returns to **开启监测** and shows **已关闭** without leaving the screen

## Downloads

- `releases/NDZ-2.0.apk` — unified five-mode edition, versionCode 12 / versionName 2.0
- `releases/NDZ-1.0.apk` — historical standard edition (continuous accelerometer)
- `releases/NDZ-1.0-Eco.apk` — historical Eco-only edition
- Icon: `assets/NDZ-icon-1024.png`

All editions use package `com.example.vibrate5s` and cannot be installed side by side.

```bash
adb install -r -d -g releases/NDZ-2.0.apk
```

## Build

- `v2/` — NDZ 2.0 Java source, resources and `tools/build.ps1`
- `standard/`, `eco/` — historical 1.0 sources

The APKs in `releases/` are signed with the development keystore and are intended for sideloading, not Play Store distribution.

## Disclaimer

This is stillness detection, **not medical-grade sleep monitoring** and not a diagnosis tool. Do not rely on it for medical or safety-critical alerts.

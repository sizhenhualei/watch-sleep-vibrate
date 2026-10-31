# NDZ — NoDoze for Wear OS

**NDZ** is the short name for **NoDoze**, a tiny Wear OS app that watches for long stillness and vibrates to wake you. The Chinese in-app title is still **别睡**.

This repository ships two editions of the same app:

| Edition | Release | Best for | Monitoring strategy |
|---|---|---|---|
| **NDZ 1.0** | `v1.0` | Reliability first | Continuous accelerometer monitoring (6.25 Hz) + foreground service |
| **NDZ 1.0 Eco** | `v1.0-eco` | Battery first | Wake-up `device_orientation` + `wrist_tilt_gesture` sensors + exact `AlarmManager` alarm; WakeLock only while the alarm is firing |

Both editions share the same package name (`com.example.vibrate5s`) and cannot be installed side by side. Uninstall one before installing the other.

## Downloads

- `releases/NDZ-1.0.apk` — standard edition, versionCode 10 / versionName 1.0
- `releases/NDZ-1.0-Eco.apk` — power-saving edition, versionCode 11 / versionName 1.0-eco
- Icon: `assets/NDZ-icon-1024.png`

```bash
adb install -r -d -g releases/NDZ-1.0.apk
# or
adb install -r -d -g releases/NDZ-1.0-Eco.apk
```

## Shared behavior

- Stillness threshold: **1–999 s**, default **180 s**
- Vibration strength: **1–255**, default **255**
- Vibration interval: **1–30 s**, default **3 s**
- Each pulse: **800 ms**
- Moving the watch stops the alarm and restarts the timer
- Foreground-service notification keeps the monitor alive
- Numeric settings UI designed for the 450×450 round watch screen
- Tested on Samsung Galaxy Watch4 (SM-R870), Wear OS / Android 16

## Standard vs Eco

**NDZ 1.0** keeps the accelerometer running continuously and holds a partial WakeLock. It is the most predictable edition, at the cost of higher battery use.

**NDZ 1.0 Eco** does not keep a permanent WakeLock. It listens for wake-up orientation / wrist-tilt events, schedules an exact alarm for `lastMovement + threshold`, and only acquires a short alarm WakeLock when the alarm actually fires. This is the low-power edition.

## Build

Each edition is self-contained:

- `standard/` — NDZ 1.0 source and `tools/build.ps1`
- `eco/` — NDZ 1.0 Eco source and `tools/build.ps1`

The APKs in `releases/` are signed with the development keystore and are intended for sideloading, not Play Store distribution.

## Disclaimer

This is accelerometer/orientation stillness detection, **not medical-grade sleep monitoring** and not a diagnosis tool. Do not rely on it for medical or safety-critical alerts.

# 别睡 / BieShui

一个 Wear OS 小工具：检测手表是否长时间静止，静止 30 秒后开始震动提醒；检测到移动后停止，并重新计时。

> 这是加速度计“静止检测”，不是医疗级睡眠检测，不能判断真实睡眠阶段。

## 功能

- 前台服务 + 加速度计监测
- 静止 30 秒后开始震动
- 警报期间每 3 秒震动 800ms
- 检测到移动后停止警报，重新等待 30 秒
- 主界面提供“停止监测”按钮

## 已验证设备

- Samsung Galaxy Watch4（SM-R870）
- Wear OS / Android 16
- minSdk 28，targetSdk 30

## 安装

```bash
adb install -r dist/bieshui.apk
```

安装后打开“别睡”，服务会自动启动；点“停止监测”会停止服务并退出界面。

## 项目结构

```text
AndroidManifest.xml
smali/com/example/vibrate5s/
  MainActivity.smali
  MainActivity$1.smali
  VibrateService.smali
  VibrateService$1.smali   # 加速度计监听
  VibrateService$2.smali   # 30 秒计时与震动逻辑
tools/build.ps1            # 构建脚本
tools/pack.py              # 把 classes.dex 合入 APK
dist/bieshui.apk           # 已签名的调试版 APK
```

## 构建

依赖：

- JDK（`java`、`apksigner` 需要）
- Android build-tools（`aapt`、`zipalign`、`apksigner`）
- Android platform 的 `android.jar`
- [smali/baksmali](https://github.com/JesusFreke/smali) 2.5.2
- Python 3

示例：

```powershell
.\tools\build.ps1 `
  -SmaliJar  "C:\path\to\smali-2.5.2.jar" `
  -SmaliDeps "C:\path\to\smali-deps\*" `
  -AndroidJar "C:\path\to\android-35\android.jar" `
  -BuildTools "C:\path\to\build-tools\35.0.0" `
  -Keystore "C:\Users\me\.android\debug.keystore"
```

脚本默认使用 `java`、`python`，并用 debug keystore 签名。发布前请换成自己的签名。

## 说明

- 本项目是手工 smali 工程，没有 Gradle。
- 三星 W 系列可能会对后台应用做冻结/省电限制；如果服务被系统杀掉，需要把“别睡”加入电池白名单或保持前台通知。
- 本项目仅用于个人学习与自用，不构成医疗建议。

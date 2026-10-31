.class public Lcom/example/vibrate5s/VibrateService;
.super Landroid/app/Service;
.source "VibrateService.java"

.field public static final ALARM_ACTION:Ljava/lang/String; = "com.example.vibrate5s.action.ALARM"

.field public thresholdMs:J

.field public intervalMs:J

.field public amplitude:I

.field public orientationSensor:Landroid/hardware/Sensor;

.field public wristSensor:Landroid/hardware/Sensor;

.field public alarmActive:Z

.field public alarmStart:J

.field public pulseRunnable:Ljava/lang/Runnable;

.field public handler:Landroid/os/Handler;

.field public lastMovement:J

.field public listener:Landroid/hardware/SensorEventListener;

.field public sensorManager:Landroid/hardware/SensorManager;

.field public vibrator:Landroid/os/Vibrator;

.field public wakeLock:Landroid/os/PowerManager$WakeLock;

.field public alarmManager:Landroid/app/AlarmManager;

.field public alarmIntent:Landroid/app/PendingIntent;

.field public showIntent:Landroid/app/PendingIntent;

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    return-void
.end method

.method public onCreate()V
    .registers 10

    invoke-super {p0}, Landroid/app/Service;->onCreate()V

    invoke-static {p0}, Lcom/example/vibrate5s/VibrateService;->startInForeground(Landroid/app/Service;)V

    const-string v0, "power"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/os/PowerManager;

    const/4 v1, 0x1
    const-string v2, "BieShui:Alarm"
    invoke-virtual {v0, v1, v2}, Landroid/os/PowerManager;->newWakeLock(ILjava/lang/String;)Landroid/os/PowerManager$WakeLock;
    move-result-object v0
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->wakeLock:Landroid/os/PowerManager$WakeLock;

    new-instance v0, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v1
    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->handler:Landroid/os/Handler;

    new-instance v0, Lcom/example/vibrate5s/VibrateService$1;
    invoke-direct {v0, p0}, Lcom/example/vibrate5s/VibrateService$1;-><init>(Lcom/example/vibrate5s/VibrateService;)V
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->listener:Landroid/hardware/SensorEventListener;

    new-instance v0, Lcom/example/vibrate5s/VibrateService$2;
    invoke-direct {v0, p0}, Lcom/example/vibrate5s/VibrateService$2;-><init>(Lcom/example/vibrate5s/VibrateService;)V
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->pulseRunnable:Ljava/lang/Runnable;

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I
    const/16 v1, 0x1f
    if-lt v0, v1, :cond_vib_old

    const-string v0, "vibrator_manager"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/os/VibratorManager;
    invoke-virtual {v0}, Landroid/os/VibratorManager;->getDefaultVibrator()Landroid/os/Vibrator;
    move-result-object v0
    goto :cond_vib_done

    :cond_vib_old
    const-string v0, "vibrator"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/os/Vibrator;

    :cond_vib_done
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->vibrator:Landroid/os/Vibrator;

    const-string v0, "sensor"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/hardware/SensorManager;
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->sensorManager:Landroid/hardware/SensorManager;

    const-string v0, "alarm"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/app/AlarmManager;
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmManager:Landroid/app/AlarmManager;

    new-instance v0, Landroid/content/Intent;
    const-class v1, Lcom/example/vibrate5s/VibrateService;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    const-string v1, "com.example.vibrate5s.action.ALARM"
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;
    move-result-object v0
    const/4 v1, 0x1
    const v2, 0xc000000
    invoke-static {p0, v1, v0, v2}, Landroid/app/PendingIntent;->getForegroundService(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;
    move-result-object v0
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmIntent:Landroid/app/PendingIntent;

    new-instance v0, Landroid/content/Intent;
    const-class v1, Lcom/example/vibrate5s/MainActivity;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    const/4 v1, 0x0
    const v2, 0xc000000
    invoke-static {p0, v1, v0, v2}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;
    move-result-object v0
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->showIntent:Landroid/app/PendingIntent;

    invoke-virtual {p0}, Lcom/example/vibrate5s/VibrateService;->reloadSettings()V

    invoke-virtual {p0}, Lcom/example/vibrate5s/VibrateService;->registerSensors()V

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    iput-wide v0, p0, Lcom/example/vibrate5s/VibrateService;->lastMovement:J

    invoke-virtual {p0}, Lcom/example/vibrate5s/VibrateService;->scheduleAlarm()V

    return-void
.end method

.method public static startInForeground(Landroid/app/Service;)V
    .registers 5

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I
    const/16 v1, 0x1a
    if-lt v0, v1, :cond_channel_done

    new-instance v0, Landroid/app/NotificationChannel;
    const-string v1, "bieshui"
    const-string v2, "\u522b\u7761"
    const/4 v3, 0x2
    invoke-direct {v0, v1, v2, v3}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    const-string v1, "notification"
    invoke-virtual {p0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/app/NotificationManager;

    invoke-virtual {v1, v0}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    :cond_channel_done

    new-instance v0, Landroid/app/Notification$Builder;
    const-string v1, "bieshui"
    invoke-direct {v0, p0, v1}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    const-string v1, "\u522b\u7761\uff1a\u76d1\u6d4b\u4e2d"
    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;
    move-result-object v0

    const-string v1, "\u9759\u6b62\u540e\u81ea\u52a8\u63d0\u9192"
    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;
    move-result-object v0

    sget v1, Landroid/R$drawable;->stat_notify_sync:I
    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;
    move-result-object v0

    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setOngoing(Z)Landroid/app/Notification$Builder;
    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;
    move-result-object v0

    const/4 v1, 0x1
    invoke-virtual {p0, v1, v0}, Landroid/app/Service;->startForeground(ILandroid/app/Notification;)V

    return-void
.end method

.method public reloadSettings()V
    .registers 8

    const-string v0, "settings"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0

    const-string v1, "threshold_sec"
    const/16 v2, 0xb4
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v2

    int-to-long v3, v2
    const-wide/16 v5, 0x3e8
    mul-long/2addr v3, v5
    iput-wide v3, p0, Lcom/example/vibrate5s/VibrateService;->thresholdMs:J

    const-string v1, "amplitude"
    const/16 v2, 0xff
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v2
    iput v2, p0, Lcom/example/vibrate5s/VibrateService;->amplitude:I

    const-string v1, "interval_sec"
    const/4 v2, 0x3
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v2

    int-to-long v3, v2
    const-wide/16 v5, 0x3e8
    mul-long/2addr v3, v5
    iput-wide v3, p0, Lcom/example/vibrate5s/VibrateService;->intervalMs:J

    return-void
.end method

.method public getSensorByType(I)Landroid/hardware/Sensor;
    .registers 5

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->sensorManager:Landroid/hardware/SensorManager;
    if-eqz v0, :cond_null

    invoke-virtual {v0, p1}, Landroid/hardware/SensorManager;->getDefaultSensor(I)Landroid/hardware/Sensor;
    move-result-object v1
    if-nez v1, :cond_ret_v1

    invoke-virtual {v0, p1}, Landroid/hardware/SensorManager;->getSensorList(I)Ljava/util/List;
    move-result-object v0
    if-eqz v0, :cond_null

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z
    move-result v1
    if-nez v1, :cond_null

    const/4 v1, 0x0
    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/hardware/Sensor;
    return-object v0

    :cond_null
    const/4 v0, 0x0
    return-object v0

    :cond_ret_v1
    return-object v1
.end method

.method public registerSensors()V
    .registers 6

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->sensorManager:Landroid/hardware/SensorManager;
    if-eqz v0, :cond_ret

    const/16 v2, 0x1b
    invoke-virtual {p0, v2}, Lcom/example/vibrate5s/VibrateService;->getSensorByType(I)Landroid/hardware/Sensor;
    move-result-object v2
    iput-object v2, p0, Lcom/example/vibrate5s/VibrateService;->orientationSensor:Landroid/hardware/Sensor;

    const/16 v3, 0x1a
    invoke-virtual {p0, v3}, Lcom/example/vibrate5s/VibrateService;->getSensorByType(I)Landroid/hardware/Sensor;
    move-result-object v3
    iput-object v3, p0, Lcom/example/vibrate5s/VibrateService;->wristSensor:Landroid/hardware/Sensor;

    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->listener:Landroid/hardware/SensorEventListener;
    const/4 v4, 0x3

    if-eqz v2, :cond_wrist
    invoke-virtual {v0, v1, v2, v4}, Landroid/hardware/SensorManager;->registerListener(Landroid/hardware/SensorEventListener;Landroid/hardware/Sensor;I)Z

    :cond_wrist
    if-eqz v3, :cond_ret
    invoke-virtual {v0, v1, v3, v4}, Landroid/hardware/SensorManager;->registerListener(Landroid/hardware/SensorEventListener;Landroid/hardware/Sensor;I)Z

    :cond_ret
    return-void
.end method

.method public onMovement()V
    .registers 4

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    iput-wide v0, p0, Lcom/example/vibrate5s/VibrateService;->lastMovement:J

    iget-boolean v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmActive:Z
    if-eqz v0, :cond_schedule

    const/4 v0, 0x1
    invoke-virtual {p0, v0}, Lcom/example/vibrate5s/VibrateService;->stopAlarm(Z)V
    return-void

    :cond_schedule
    invoke-virtual {p0}, Lcom/example/vibrate5s/VibrateService;->scheduleAlarm()V
    return-void
.end method

.method public scheduleAlarm()V
    .registers 6

    iget-boolean v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmActive:Z
    if-nez v0, :cond_ret

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmManager:Landroid/app/AlarmManager;
    if-eqz v0, :cond_ret

    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->alarmIntent:Landroid/app/PendingIntent;
    if-eqz v1, :cond_ret

    invoke-virtual {v0, v1}, Landroid/app/AlarmManager;->cancel(Landroid/app/PendingIntent;)V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0
    iget-wide v2, p0, Lcom/example/vibrate5s/VibrateService;->thresholdMs:J
    add-long/2addr v0, v2

    iget-object v2, p0, Lcom/example/vibrate5s/VibrateService;->showIntent:Landroid/app/PendingIntent;
    new-instance v3, Landroid/app/AlarmManager$AlarmClockInfo;
    invoke-direct {v3, v0, v1, v2}, Landroid/app/AlarmManager$AlarmClockInfo;-><init>(JLandroid/app/PendingIntent;)V

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmManager:Landroid/app/AlarmManager;
    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->alarmIntent:Landroid/app/PendingIntent;
    invoke-virtual {v0, v3, v1}, Landroid/app/AlarmManager;->setAlarmClock(Landroid/app/AlarmManager$AlarmClockInfo;Landroid/app/PendingIntent;)V

    :cond_ret
    return-void
.end method

.method public cancelAlarm()V
    .registers 3

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmManager:Landroid/app/AlarmManager;
    if-eqz v0, :cond_ret

    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->alarmIntent:Landroid/app/PendingIntent;
    if-eqz v1, :cond_ret

    invoke-virtual {v0, v1}, Landroid/app/AlarmManager;->cancel(Landroid/app/PendingIntent;)V

    :cond_ret
    return-void
.end method

.method public startAlarm()V
    .registers 5

    iget-boolean v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmActive:Z
    if-nez v0, :cond_ret

    invoke-virtual {p0}, Lcom/example/vibrate5s/VibrateService;->cancelAlarm()V

    const/4 v0, 0x1
    iput-boolean v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmActive:Z

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    iput-wide v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmStart:J

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->wakeLock:Landroid/os/PowerManager$WakeLock;
    if-eqz v0, :cond_post
    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->acquire()V

    :cond_post
    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->handler:Landroid/os/Handler;
    if-eqz v0, :cond_ret
    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->pulseRunnable:Ljava/lang/Runnable;
    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :cond_ret
    return-void
.end method

.method public pulse()V
    .registers 5

    iget-boolean v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmActive:Z
    if-eqz v0, :cond_ret

    invoke-virtual {p0}, Lcom/example/vibrate5s/VibrateService;->vibrateOnce()V

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->handler:Landroid/os/Handler;
    if-eqz v0, :cond_ret
    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->pulseRunnable:Ljava/lang/Runnable;
    iget-wide v2, p0, Lcom/example/vibrate5s/VibrateService;->intervalMs:J
    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :cond_ret
    return-void
.end method

.method public stopAlarm(Z)V
    .registers 4

    iget-boolean v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmActive:Z
    if-eqz v0, :cond_after

    const/4 v0, 0x0
    iput-boolean v0, p0, Lcom/example/vibrate5s/VibrateService;->alarmActive:Z

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->handler:Landroid/os/Handler;
    if-eqz v0, :cond_lock
    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->pulseRunnable:Ljava/lang/Runnable;
    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    :cond_lock
    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->wakeLock:Landroid/os/PowerManager$WakeLock;
    if-eqz v0, :cond_after
    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->isHeld()Z
    move-result v1
    if-eqz v1, :cond_after
    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->release()V

    :cond_after
    if-eqz p1, :cond_ret
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    iput-wide v0, p0, Lcom/example/vibrate5s/VibrateService;->lastMovement:J
    invoke-virtual {p0}, Lcom/example/vibrate5s/VibrateService;->scheduleAlarm()V

    :cond_ret
    return-void
.end method

.method public vibrateOnce()V
    .registers 5

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->vibrator:Landroid/os/Vibrator;
    if-eqz v0, :cond_end

    const-wide/16 v1, 0x320
    iget v3, p0, Lcom/example/vibrate5s/VibrateService;->amplitude:I
    invoke-static {v1, v2, v3}, Landroid/os/VibrationEffect;->createOneShot(JI)Landroid/os/VibrationEffect;
    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/os/Vibrator;->vibrate(Landroid/os/VibrationEffect;)V

    :cond_end
    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .registers 7

    invoke-virtual {p0}, Lcom/example/vibrate5s/VibrateService;->reloadSettings()V

    if-eqz p1, :cond_normal

    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :cond_normal
    const-string v1, "com.example.vibrate5s.action.ALARM"
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_normal

    invoke-virtual {p0}, Lcom/example/vibrate5s/VibrateService;->startAlarm()V
    goto :done

    :cond_normal
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    iput-wide v0, p0, Lcom/example/vibrate5s/VibrateService;->lastMovement:J
    invoke-virtual {p0}, Lcom/example/vibrate5s/VibrateService;->scheduleAlarm()V

    :done
    const/4 v0, 0x1
    return v0
.end method

.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .registers 3

    const/4 v0, 0x0
    return-object v0
.end method

.method public onDestroy()V
    .registers 4

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->sensorManager:Landroid/hardware/SensorManager;
    if-eqz v0, :cond_sensor
    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->listener:Landroid/hardware/SensorEventListener;
    invoke-virtual {v0, v1}, Landroid/hardware/SensorManager;->unregisterListener(Landroid/hardware/SensorEventListener;)V

    :cond_sensor
    invoke-virtual {p0}, Lcom/example/vibrate5s/VibrateService;->cancelAlarm()V

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->handler:Landroid/os/Handler;
    if-eqz v0, :cond_handler
    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->pulseRunnable:Ljava/lang/Runnable;
    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    :cond_handler
    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Lcom/example/vibrate5s/VibrateService;->stopAlarm(Z)V

    const/4 v0, 0x1
    invoke-virtual {p0, v0}, Landroid/app/Service;->stopForeground(Z)V
    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    return-void
.end method

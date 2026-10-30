.class public Lcom/example/vibrate5s/VibrateService;
.super Landroid/app/Service;
.source "VibrateService.java"

.field public static final ALARM_INTERVAL:J = 0xbb8L

.field public static final THRESHOLD:J = 0x7530L

.field public static final VIBRATE_MS:J = 0x320L

.field public accelerometer:Landroid/hardware/Sensor;

.field public alarmActive:Z

.field public checkRunnable:Ljava/lang/Runnable;

.field public handler:Landroid/os/Handler;

.field public lastMovement:J

.field public listener:Landroid/hardware/SensorEventListener;

.field public sensorManager:Landroid/hardware/SensorManager;

.field public vibrator:Landroid/os/Vibrator;

.field public wakeLock:Landroid/os/PowerManager$WakeLock;

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    return-void
.end method

.method public onCreate()V
    .registers 9

    invoke-super {p0}, Landroid/app/Service;->onCreate()V

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I
    const/16 v1, 0x1a
    if-lt v0, v1, :cond_channel_done

    new-instance v0, Landroid/app/NotificationChannel;
    const-string v1, "bieshui"
    const-string v2, "别睡"
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

    const-string v1, "别睡：监测中"
    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;
    move-result-object v0

    const-string v1, "静止 30 秒后震动"
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

    const-string v0, "power"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/os/PowerManager;

    const/4 v1, 0x1
    const-string v2, "BieShui"
    invoke-virtual {v0, v1, v2}, Landroid/os/PowerManager;->newWakeLock(ILjava/lang/String;)Landroid/os/PowerManager$WakeLock;
    move-result-object v0
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->wakeLock:Landroid/os/PowerManager$WakeLock;
    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->acquire()V

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

    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/hardware/SensorManager;->getDefaultSensor(I)Landroid/hardware/Sensor;
    move-result-object v0
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->accelerometer:Landroid/hardware/Sensor;

    new-instance v0, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v1
    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->handler:Landroid/os/Handler;

    new-instance v0, Lcom/example/vibrate5s/VibrateService$1;
    invoke-direct {v0, p0}, Lcom/example/vibrate5s/VibrateService$1;-><init>(Lcom/example/vibrate5s/VibrateService;)V
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->listener:Landroid/hardware/SensorEventListener;

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->sensorManager:Landroid/hardware/SensorManager;
    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->listener:Landroid/hardware/SensorEventListener;
    iget-object v2, p0, Lcom/example/vibrate5s/VibrateService;->accelerometer:Landroid/hardware/Sensor;
    const/4 v3, 0x3
    invoke-virtual {v0, v1, v2, v3}, Landroid/hardware/SensorManager;->registerListener(Landroid/hardware/SensorEventListener;Landroid/hardware/Sensor;I)Z

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    iput-wide v0, p0, Lcom/example/vibrate5s/VibrateService;->lastMovement:J

    new-instance v0, Lcom/example/vibrate5s/VibrateService$2;
    invoke-direct {v0, p0}, Lcom/example/vibrate5s/VibrateService$2;-><init>(Lcom/example/vibrate5s/VibrateService;)V
    iput-object v0, p0, Lcom/example/vibrate5s/VibrateService;->checkRunnable:Ljava/lang/Runnable;

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->handler:Landroid/os/Handler;
    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->checkRunnable:Ljava/lang/Runnable;
    const-wide/16 v2, 0x3e8
    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method public vibrateOnce()V
    .registers 5

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->vibrator:Landroid/os/Vibrator;
    if-eqz v0, :cond_end

    const-wide/16 v1, 0x320
    const/4 v3, -0x1
    invoke-static {v1, v2, v3}, Landroid/os/VibrationEffect;->createOneShot(JI)Landroid/os/VibrationEffect;
    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/os/Vibrator;->vibrate(Landroid/os/VibrationEffect;)V

    :cond_end
    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .registers 5

    const/4 v0, 0x1
    return v0
.end method

.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .registers 3

    const/4 v0, 0x0
    return-object v0
.end method

.method public onDestroy()V
    .registers 3

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->sensorManager:Landroid/hardware/SensorManager;
    if-eqz v0, :cond_sensor

    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->listener:Landroid/hardware/SensorEventListener;
    invoke-virtual {v0, v1}, Landroid/hardware/SensorManager;->unregisterListener(Landroid/hardware/SensorEventListener;)V

    :cond_sensor
    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->handler:Landroid/os/Handler;
    if-eqz v0, :cond_handler

    iget-object v1, p0, Lcom/example/vibrate5s/VibrateService;->checkRunnable:Ljava/lang/Runnable;
    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    :cond_handler
    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService;->wakeLock:Landroid/os/PowerManager$WakeLock;
    if-eqz v0, :cond_lock

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->release()V

    :cond_lock
    const/4 v0, 0x1
    invoke-virtual {p0, v0}, Landroid/app/Service;->stopForeground(Z)V
    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    return-void
.end method

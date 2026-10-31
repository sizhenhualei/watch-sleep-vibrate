.class public Lcom/example/vibrate5s/VibrateService$1;
.super Ljava/lang/Object;
.implements Landroid/hardware/SensorEventListener;
.source "VibrateService.java"

.field final synthetic this$0:Lcom/example/vibrate5s/VibrateService;

.method constructor <init>(Lcom/example/vibrate5s/VibrateService;)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/example/vibrate5s/VibrateService$1;->this$0:Lcom/example/vibrate5s/VibrateService;

    return-void
.end method

.method public onSensorChanged(Landroid/hardware/SensorEvent;)V
    .registers 7

    iget-object v0, p1, Landroid/hardware/SensorEvent;->values:[F

    const/4 v1, 0x0
    aget v2, v0, v1

    const/4 v1, 0x1
    aget v3, v0, v1

    const/4 v1, 0x2
    aget v4, v0, v1

    mul-float/2addr v2, v2
    mul-float/2addr v3, v3
    add-float/2addr v2, v3
    mul-float/2addr v4, v4
    add-float/2addr v2, v4

    const v3, 0x42dc0000

    cmpl-float v3, v2, v3
    if-gtz v3, :cond_movement

    :cond_check_low
    const v3, 0x42a00000

    cmpl-float v3, v2, v3
    if-ltz v3, :cond_movement

    return-void

    :cond_movement
    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService$1;->this$0:Lcom/example/vibrate5s/VibrateService;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v2

    iput-wide v2, v0, Lcom/example/vibrate5s/VibrateService;->lastMovement:J

    return-void
.end method

.method public onAccuracyChanged(Landroid/hardware/Sensor;I)V
    .registers 3

    return-void
.end method

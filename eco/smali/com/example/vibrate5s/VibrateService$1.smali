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
    .registers 2

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService$1;->this$0:Lcom/example/vibrate5s/VibrateService;
    invoke-virtual {v0}, Lcom/example/vibrate5s/VibrateService;->onMovement()V

    return-void
.end method

.method public onAccuracyChanged(Landroid/hardware/Sensor;I)V
    .registers 3

    return-void
.end method

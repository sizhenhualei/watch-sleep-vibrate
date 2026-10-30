.class public Lcom/example/vibrate5s/VibrateService$2;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.source "VibrateService.java"

.field final synthetic this$0:Lcom/example/vibrate5s/VibrateService;

.method constructor <init>(Lcom/example/vibrate5s/VibrateService;)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/example/vibrate5s/VibrateService$2;->this$0:Lcom/example/vibrate5s/VibrateService;

    return-void
.end method

.method public run()V
    .registers 8

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService$2;->this$0:Lcom/example/vibrate5s/VibrateService;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v2

    iget-boolean v1, v0, Lcom/example/vibrate5s/VibrateService;->alarmActive:Z
    if-eqz v1, :cond_normal

    iget-wide v4, v0, Lcom/example/vibrate5s/VibrateService;->lastMovement:J
    sub-long/2addr v2, v4

    const-wide/16 v4, 0x5dc
    cmp-long v6, v2, v4
    if-ltz v6, :cond_stop_alarm

    invoke-virtual {v0}, Lcom/example/vibrate5s/VibrateService;->vibrateOnce()V

    goto :post_3s

    :cond_stop_alarm
    const/4 v1, 0x0
    iput-boolean v1, v0, Lcom/example/vibrate5s/VibrateService;->alarmActive:Z

    goto :post_1s

    :cond_normal
    iget-wide v4, v0, Lcom/example/vibrate5s/VibrateService;->lastMovement:J
    sub-long/2addr v2, v4

    const-wide/16 v4, 0x7530
    cmp-long v6, v2, v4
    if-ltz v6, :post_1s

    const/4 v1, 0x1
    iput-boolean v1, v0, Lcom/example/vibrate5s/VibrateService;->alarmActive:Z

    invoke-virtual {v0}, Lcom/example/vibrate5s/VibrateService;->vibrateOnce()V

    :post_3s
    const-wide/16 v4, 0xbb8
    goto :post

    :post_1s
    const-wide/16 v4, 0x3e8

    :post
    iget-object v1, v0, Lcom/example/vibrate5s/VibrateService;->handler:Landroid/os/Handler;
    iget-object v2, v0, Lcom/example/vibrate5s/VibrateService;->checkRunnable:Ljava/lang/Runnable;
    invoke-virtual {v1, v2, v4, v5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

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
    .registers 2

    iget-object v0, p0, Lcom/example/vibrate5s/VibrateService$2;->this$0:Lcom/example/vibrate5s/VibrateService;
    invoke-virtual {v0}, Lcom/example/vibrate5s/VibrateService;->pulse()V

    return-void
.end method

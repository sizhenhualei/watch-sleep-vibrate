.class Lcom/example/vibrate5s/MainActivity$1;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;
.source "MainActivity.java"

.field final synthetic this$0:Lcom/example/vibrate5s/MainActivity;

.method constructor <init>(Lcom/example/vibrate5s/MainActivity;)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/example/vibrate5s/MainActivity$1;->this$0:Lcom/example/vibrate5s/MainActivity;

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .registers 5

    iget-object v0, p0, Lcom/example/vibrate5s/MainActivity$1;->this$0:Lcom/example/vibrate5s/MainActivity;

    new-instance v1, Landroid/content/Intent;
    const-class v2, Lcom/example/vibrate5s/VibrateService;
    invoke-direct {v1, v0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {v0, v1}, Landroid/content/Context;->stopService(Landroid/content/Intent;)Z

    invoke-virtual {v0}, Landroid/app/Activity;->finish()V

    return-void
.end method

.class public Lcom/example/vibrate5s/MainActivity$1;
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
    .registers 4

    iget-object v0, p0, Lcom/example/vibrate5s/MainActivity$1;->this$0:Lcom/example/vibrate5s/MainActivity;

    invoke-virtual {p1}, Landroid/view/View;->getId()I
    move-result v1

    const/16 v2, 0x3e9
    if-ne v1, v2, :cond_stop

    invoke-virtual {v0}, Lcom/example/vibrate5s/MainActivity;->saveAndRestart()V
    return-void

    :cond_stop
    invoke-virtual {v0}, Lcom/example/vibrate5s/MainActivity;->stopAndFinish()V

    return-void
.end method

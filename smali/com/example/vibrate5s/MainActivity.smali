.class public Lcom/example/vibrate5s/MainActivity;
.super Landroid/app/Activity;
.source "MainActivity.java"

.field private prefs:Landroid/content/SharedPreferences;

.field private thresholdInput:Landroid/widget/EditText;

.field private amplitudeInput:Landroid/widget/EditText;

.field private intervalInput:Landroid/widget/EditText;

.field private thresholdSec:I

.field private amplitude:I

.field private intervalSec:I

.field private clickListener:Landroid/view/View$OnClickListener;

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .registers 12

    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    const-string v0, "settings"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    iput-object v0, p0, Lcom/example/vibrate5s/MainActivity;->prefs:Landroid/content/SharedPreferences;

    invoke-direct {p0}, Lcom/example/vibrate5s/MainActivity;->loadSettings()V

    new-instance v0, Lcom/example/vibrate5s/MainActivity$1;
    invoke-direct {v0, p0}, Lcom/example/vibrate5s/MainActivity$1;-><init>(Lcom/example/vibrate5s/MainActivity;)V
    iput-object v0, p0, Lcom/example/vibrate5s/MainActivity;->clickListener:Landroid/view/View$OnClickListener;

    new-instance v0, Landroid/widget/ScrollView;
    invoke-direct {v0, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V
    const v1, -0x1000000
    invoke-virtual {v0, v1}, Landroid/widget/ScrollView;->setBackgroundColor(I)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/widget/ScrollView;->setFillViewport(Z)V
    const/16 v1, 0x28
    const/16 v2, 0x1e
    invoke-virtual {v0, v1, v2, v1, v2}, Landroid/widget/ScrollView;->setPadding(IIII)V

    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const-string v2, "别睡"
    const/high16 v3, 0x41b00000
    invoke-direct {p0, v2, v3}, Lcom/example/vibrate5s/MainActivity;->makeLabel(Ljava/lang/String;F)Landroid/widget/TextView;
    move-result-object v2
    const/16 v3, 0x11
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V
    invoke-direct {p0, v1, v2}, Lcom/example/vibrate5s/MainActivity;->addViewFull(Landroid/view/ViewGroup;Landroid/view/View;)V

    const-string v2, "静止超过设定时间后震动"
    const/high16 v3, 0x41600000
    invoke-direct {p0, v2, v3}, Lcom/example/vibrate5s/MainActivity;->makeLabel(Ljava/lang/String;F)Landroid/widget/TextView;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Lcom/example/vibrate5s/MainActivity;->addViewFull(Landroid/view/ViewGroup;Landroid/view/View;)V

    const-string v2, "判定时间（秒，10-180）"
    iget v3, p0, Lcom/example/vibrate5s/MainActivity;->thresholdSec:I
    const/16 v4, 0x7d1
    invoke-direct {p0, v2, v3, v4}, Lcom/example/vibrate5s/MainActivity;->makeInput(Ljava/lang/String;II)Landroid/widget/LinearLayout;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Lcom/example/vibrate5s/MainActivity;->addViewFull(Landroid/view/ViewGroup;Landroid/view/View;)V

    const-string v2, "震动强度（1-255）"
    iget v3, p0, Lcom/example/vibrate5s/MainActivity;->amplitude:I
    const/16 v4, 0x7d2
    invoke-direct {p0, v2, v3, v4}, Lcom/example/vibrate5s/MainActivity;->makeInput(Ljava/lang/String;II)Landroid/widget/LinearLayout;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Lcom/example/vibrate5s/MainActivity;->addViewFull(Landroid/view/ViewGroup;Landroid/view/View;)V

    const-string v2, "震动间隔（秒，1-30）"
    iget v3, p0, Lcom/example/vibrate5s/MainActivity;->intervalSec:I
    const/16 v4, 0x7d3
    invoke-direct {p0, v2, v3, v4}, Lcom/example/vibrate5s/MainActivity;->makeInput(Ljava/lang/String;II)Landroid/widget/LinearLayout;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Lcom/example/vibrate5s/MainActivity;->addViewFull(Landroid/view/ViewGroup;Landroid/view/View;)V

    const-string v2, "保存并重启监测"
    const/16 v3, 0x3e9
    invoke-direct {p0, v2, v3}, Lcom/example/vibrate5s/MainActivity;->makeButton(Ljava/lang/String;I)Landroid/widget/Button;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Lcom/example/vibrate5s/MainActivity;->addViewFull(Landroid/view/ViewGroup;Landroid/view/View;)V

    const-string v2, "停止监测"
    const/16 v3, 0x3ea
    invoke-direct {p0, v2, v3}, Lcom/example/vibrate5s/MainActivity;->makeButton(Ljava/lang/String;I)Landroid/widget/Button;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Lcom/example/vibrate5s/MainActivity;->addViewFull(Landroid/view/ViewGroup;Landroid/view/View;)V

    invoke-virtual {v0, v1}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V
    invoke-virtual {p0, v0}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V

    const/16 v1, 0x7d1
    invoke-virtual {p0, v1}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Landroid/widget/EditText;
    iput-object v1, p0, Lcom/example/vibrate5s/MainActivity;->thresholdInput:Landroid/widget/EditText;

    const/16 v1, 0x7d2
    invoke-virtual {p0, v1}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Landroid/widget/EditText;
    iput-object v1, p0, Lcom/example/vibrate5s/MainActivity;->amplitudeInput:Landroid/widget/EditText;

    const/16 v1, 0x7d3
    invoke-virtual {p0, v1}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Landroid/widget/EditText;
    iput-object v1, p0, Lcom/example/vibrate5s/MainActivity;->intervalInput:Landroid/widget/EditText;

    invoke-direct {p0}, Lcom/example/vibrate5s/MainActivity;->startMonitor()V

    return-void
.end method

.method private loadSettings()V
    .registers 5

    iget-object v0, p0, Lcom/example/vibrate5s/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "threshold_sec"
    const/16 v2, 0x3c
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v2
    iput v2, p0, Lcom/example/vibrate5s/MainActivity;->thresholdSec:I

    const-string v1, "amplitude"
    const/16 v2, 0xff
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v2
    iput v2, p0, Lcom/example/vibrate5s/MainActivity;->amplitude:I

    const-string v1, "interval_sec"
    const/4 v2, 0x3
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v2
    iput v2, p0, Lcom/example/vibrate5s/MainActivity;->intervalSec:I

    return-void
.end method

.method public saveSettings()V
    .registers 6

    iget-object v0, p0, Lcom/example/vibrate5s/MainActivity;->thresholdInput:Landroid/widget/EditText;
    const/16 v1, 0x3c
    invoke-direct {p0, v0, v1}, Lcom/example/vibrate5s/MainActivity;->readInt(Landroid/widget/EditText;I)I
    move-result v0
    const/16 v1, 0xa
    const/16 v2, 0xb4
    invoke-direct {p0, v0, v1, v2}, Lcom/example/vibrate5s/MainActivity;->clamp(III)I
    move-result v0
    iput v0, p0, Lcom/example/vibrate5s/MainActivity;->thresholdSec:I

    iget-object v0, p0, Lcom/example/vibrate5s/MainActivity;->amplitudeInput:Landroid/widget/EditText;
    const/16 v1, 0xff
    invoke-direct {p0, v0, v1}, Lcom/example/vibrate5s/MainActivity;->readInt(Landroid/widget/EditText;I)I
    move-result v0
    const/4 v1, 0x1
    const/16 v2, 0xff
    invoke-direct {p0, v0, v1, v2}, Lcom/example/vibrate5s/MainActivity;->clamp(III)I
    move-result v0
    iput v0, p0, Lcom/example/vibrate5s/MainActivity;->amplitude:I

    iget-object v0, p0, Lcom/example/vibrate5s/MainActivity;->intervalInput:Landroid/widget/EditText;
    const/4 v1, 0x3
    invoke-direct {p0, v0, v1}, Lcom/example/vibrate5s/MainActivity;->readInt(Landroid/widget/EditText;I)I
    move-result v0
    const/4 v1, 0x1
    const/16 v2, 0x1e
    invoke-direct {p0, v0, v1, v2}, Lcom/example/vibrate5s/MainActivity;->clamp(III)I
    move-result v0
    iput v0, p0, Lcom/example/vibrate5s/MainActivity;->intervalSec:I

    iget-object v0, p0, Lcom/example/vibrate5s/MainActivity;->prefs:Landroid/content/SharedPreferences;
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0

    const-string v1, "threshold_sec"
    iget v2, p0, Lcom/example/vibrate5s/MainActivity;->thresholdSec:I
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v0

    const-string v1, "amplitude"
    iget v2, p0, Lcom/example/vibrate5s/MainActivity;->amplitude:I
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v0

    const-string v1, "interval_sec"
    iget v2, p0, Lcom/example/vibrate5s/MainActivity;->intervalSec:I
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method

.method public saveAndRestart()V
    .registers 4

    invoke-virtual {p0}, Lcom/example/vibrate5s/MainActivity;->saveSettings()V
    invoke-direct {p0}, Lcom/example/vibrate5s/MainActivity;->stopMonitor()V
    invoke-direct {p0}, Lcom/example/vibrate5s/MainActivity;->startMonitor()V

    const-string v0, "已保存"
    const/4 v1, 0x0
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method public stopAndFinish()V
    .registers 1

    invoke-direct {p0}, Lcom/example/vibrate5s/MainActivity;->stopMonitor()V
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    return-void
.end method

.method private startMonitor()V
    .registers 3

    new-instance v0, Landroid/content/Intent;
    const-class v1, Lcom/example/vibrate5s/VibrateService;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p0, v0}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    return-void
.end method

.method private stopMonitor()V
    .registers 3

    new-instance v0, Landroid/content/Intent;
    const-class v1, Lcom/example/vibrate5s/VibrateService;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p0, v0}, Landroid/content/Context;->stopService(Landroid/content/Intent;)Z

    return-void
.end method

.method private readInt(Landroid/widget/EditText;I)I
    .registers 5

    :try_start_0
    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result v0
    return v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return p2
.end method

.method private clamp(III)I
    .registers 4

    if-ge p1, p2, :low
    if-gt p1, p3, :ok
    return p3

    :low
    return p2

    :ok
    return p1
.end method

.method private makeLabel(Ljava/lang/String;F)Landroid/widget/TextView;
    .registers 4

    new-instance v0, Landroid/widget/TextView;
    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setTextSize(F)V
    const/4 v1, -0x1
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    return-object v0
.end method

.method private makeInput(Ljava/lang/String;II)Landroid/widget/LinearLayout;
    .registers 9

    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v1, Landroid/widget/TextView;
    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v2, 0x41600000
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextSize(F)V
    const/4 v2, -0x1
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v1, Landroid/widget/EditText;
    invoke-direct {v1, p0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V
    invoke-static {p2}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V
    const/4 v2, 0x2
    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setInputType(I)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setSingleLine(Z)V
    const/high16 v2, 0x41900000
    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setTextSize(F)V
    const/4 v2, -0x1
    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setTextColor(I)V
    const/16 v2, 0x11
    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setGravity(I)V
    invoke-virtual {v1, p3}, Landroid/widget/EditText;->setId(I)V
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-object v0
.end method

.method private makeButton(Ljava/lang/String;I)Landroid/widget/Button;
    .registers 8

    new-instance v0, Landroid/widget/Button;
    invoke-direct {v0, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v0, p2}, Landroid/widget/Button;->setId(I)V
    const/high16 v1, 0x41700000
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setTextSize(F)V
    const/4 v1, -0x1
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setTextColor(I)V

    const/16 v1, 0x3e9
    if-ne p2, v1, :cond_secondary
    const v1, -0xea9a40
    goto :cond_bg
    :cond_secondary
    const v1, -0xcccdcd

    :cond_bg
    new-instance v2, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    invoke-virtual {v2, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    const/high16 v3, 0x41c00000
    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v0, v2}, Landroid/widget/Button;->setBackground(Landroid/graphics/drawable/Drawable;)V
    const/16 v1, 0x18
    const/16 v3, 0xc
    invoke-virtual {v0, v1, v3, v1, v3}, Landroid/widget/Button;->setPadding(IIII)V

    iget-object v1, p0, Lcom/example/vibrate5s/MainActivity;->clickListener:Landroid/view/View$OnClickListener;
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-object v0
.end method

.method private addViewFull(Landroid/view/ViewGroup;Landroid/view/View;)V
    .registers 7

    new-instance v0, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v1, -0x1
    const/4 v2, -0x2
    invoke-direct {v0, v1, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/4 v1, 0x0
    const/16 v2, 0x8
    invoke-virtual {v0, v1, v1, v1, v2}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V
    invoke-virtual {p1, p2, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-void
.end method

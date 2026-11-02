package com.example.vibrate5s;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity {

    public static final String PREFS = "settings";
    public static final String KEY_MODE = "mode";
    public static final String KEY_THRESHOLD = "threshold_sec";
    public static final String KEY_AMPLITUDE = "amplitude";
    public static final String KEY_INTERVAL = "interval_sec";
    public static final String KEY_RUNNING = "running";

    public static final int ID_START = 0x3e9;
    public static final int ID_STOP = 0x3ea;

    private static final int ID_MODE_ECO = 0x7e1;
    private static final int ID_MODE_LOW = 0x7e2;
    private static final int ID_MODE_HIGH = 0x7e3;
    private static final int ID_MODE_MAX = 0x7e4;
    private static final int ID_MODE_SIXTY = 0x7e5;

    private static final int ID_THRESHOLD = 0x7d1;
    private static final int ID_AMPLITUDE = 0x7d2;
    private static final int ID_INTERVAL = 0x7d3;

    private SharedPreferences prefs;
    private EditText thresholdInput;
    private EditText amplitudeInput;
    private EditText intervalInput;
    private TextView thresholdLabel;
    private TextView modeHint;
    private TextView statusView;
    private RadioGroup modeGroup;
    private Button startButton;
    private Button stopButton;
    private Handler autoSaveHandler;
    private Runnable autoSaveRunnable;

    private int mode = MonitorService.MODE_ECO;
    private int thresholdSec = 180;
    private int amplitude = 255;
    private int intervalSec = 3;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        prefs = getSharedPreferences(PREFS, MODE_PRIVATE);
        loadSettings();

        ScrollView scroll = new ScrollView(this);
        scroll.setBackgroundColor(Color.BLACK);
        scroll.setFillViewport(true);
        scroll.setPadding(30, 24, 30, 24);

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setGravity(Gravity.CENTER_HORIZONTAL);

        TextView title = makeLabel("NDZ", 30f, Color.WHITE);
        title.setGravity(Gravity.CENTER);
        title.setTypeface(null, android.graphics.Typeface.BOLD);
        add(root, title);

        TextView subtitle = makeLabel("别睡 · 静止提醒", 15f, Color.parseColor("#B0BEC5"));
        subtitle.setGravity(Gravity.CENTER);
        add(root, subtitle);

        statusView = makeLabel("已关闭", 20f, Color.parseColor("#90A4AE"));
        statusView.setGravity(Gravity.CENTER);
        statusView.setPadding(0, 14, 0, 8);
        add(root, statusView);

        TextView modeLabel = makeLabel("监测模式", 14f, Color.parseColor("#B0BEC5"));
        modeLabel.setPadding(0, 8, 0, 2);
        add(root, modeLabel);

        modeGroup = new RadioGroup(this);
        modeGroup.setOrientation(RadioGroup.VERTICAL);
        modeGroup.addView(makeMode("Eco · 事件驱动", ID_MODE_ECO));
        modeGroup.addView(makeMode("一分钟 · 60 秒采样", ID_MODE_SIXTY));
        modeGroup.addView(makeMode("低功耗 · 30 秒采样", ID_MODE_LOW));
        modeGroup.addView(makeMode("高频 · 15 秒采样", ID_MODE_HIGH));
        modeGroup.addView(makeMode("持续 · 最灵敏", ID_MODE_MAX));
        add(root, modeGroup);

        modeHint = makeLabel("", 13f, Color.parseColor("#90A4AE"));
        modeHint.setGravity(Gravity.CENTER);
        modeHint.setPadding(0, 4, 0, 4);
        add(root, modeHint);

        thresholdInput = makeInput(root, "Eco 判定时间（秒，1-999）", thresholdSec, ID_THRESHOLD);

        TextView commonLabel = makeLabel("通用设置", 14f, Color.parseColor("#B0BEC5"));
        commonLabel.setPadding(0, 10, 0, 2);
        add(root, commonLabel);

        amplitudeInput = makeInput(root, "震动强度（1-255）", amplitude, ID_AMPLITUDE);
        intervalInput = makeInput(root, "震动间隔（秒，1-30）", intervalSec, ID_INTERVAL);

        startButton = makeButton("开启监测", ID_START, Color.parseColor("#1565C0"));
        add(root, startButton);

        stopButton = makeButton("关闭监测", ID_STOP, Color.parseColor("#333333"));
        add(root, stopButton);

        scroll.addView(root, new ScrollView.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        setContentView(scroll);

        View.OnClickListener click = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int id = v.getId();
                if (id == ID_START) {
                    startMonitor();
                } else if (id == ID_STOP) {
                    stopMonitor();
                }
            }
        };
        startButton.setOnClickListener(click);
        stopButton.setOnClickListener(click);

        autoSaveHandler = new Handler(Looper.getMainLooper());
        autoSaveRunnable = new Runnable() {
            @Override
            public void run() {
                autoSave();
            }
        };

        selectMode(mode);
        modeGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                updateModeUi();
                scheduleAutoSave();
            }
        });
        addAutoSave(thresholdInput);
        addAutoSave(amplitudeInput);
        addAutoSave(intervalInput);
        updateModeUi();
        updateRunningUi();
    }

    @Override
    protected void onResume() {
        super.onResume();
        updateRunningUi();
    }

    @Override
    protected void onPause() {
        if (autoSaveHandler != null && autoSaveRunnable != null) {
            autoSaveHandler.removeCallbacks(autoSaveRunnable);
            autoSave();
        }
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        if (autoSaveHandler != null && autoSaveRunnable != null) {
            autoSaveHandler.removeCallbacks(autoSaveRunnable);
        }
        super.onDestroy();
    }

    private void updateModeUi() {
        boolean eco = selectedMode() == MonitorService.MODE_ECO;
        int visibility = eco ? View.VISIBLE : View.GONE;
        if (thresholdLabel != null) thresholdLabel.setVisibility(visibility);
        if (thresholdInput != null) thresholdInput.setVisibility(visibility);
        if (modeHint != null) {
            if (eco) {
                modeHint.setText("事件驱动 · 判定时间可调 · 静止后 30 秒确认");
            } else if (selectedMode() == MonitorService.MODE_SIXTY) {
                modeHint.setText("固定策略 · 60 秒采样 → 30 秒确认（约 90 秒）");
            } else if (selectedMode() == MonitorService.MODE_LOW) {
                modeHint.setText("固定策略 · 30 秒采样 → 30 秒确认（约 60 秒）");
            } else if (selectedMode() == MonitorService.MODE_HIGH) {
                modeHint.setText("固定策略 · 15 秒采样 → 30 秒确认（约 45 秒）");
            } else {
                modeHint.setText("固定策略 · 连续监测 → 30 秒确认（约 30 秒）");
            }
        }
    }

    private void addAutoSave(EditText input) {
        if (input == null) return;
        input.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                scheduleAutoSave();
            }
        });
    }

    private void scheduleAutoSave() {
        if (autoSaveHandler == null || autoSaveRunnable == null) return;
        autoSaveHandler.removeCallbacks(autoSaveRunnable);
        autoSaveHandler.postDelayed(autoSaveRunnable, 600L);
    }

    private void autoSave() {
        saveSettings();
        if (MonitorService.RUNNING) {
            restartMonitor();
        }
    }

    private void loadSettings() {
        mode = prefs.getInt(KEY_MODE, MonitorService.MODE_ECO);
        thresholdSec = prefs.getInt(KEY_THRESHOLD, 180);
        amplitude = prefs.getInt(KEY_AMPLITUDE, 255);
        intervalSec = prefs.getInt(KEY_INTERVAL, 3);
    }

    private void selectMode(int value) {
        int id;
        switch (value) {
            case MonitorService.MODE_LOW: id = ID_MODE_LOW; break;
            case MonitorService.MODE_HIGH: id = ID_MODE_HIGH; break;
            case MonitorService.MODE_MAX: id = ID_MODE_MAX; break;
            case MonitorService.MODE_SIXTY: id = ID_MODE_SIXTY; break;
            case MonitorService.MODE_ECO:
            default: id = ID_MODE_ECO; break;
        }
        modeGroup.check(id);
    }

    private int selectedMode() {
        int id = modeGroup.getCheckedRadioButtonId();
        if (id == ID_MODE_LOW) return MonitorService.MODE_LOW;
        if (id == ID_MODE_HIGH) return MonitorService.MODE_HIGH;
        if (id == ID_MODE_MAX) return MonitorService.MODE_MAX;
        if (id == ID_MODE_SIXTY) return MonitorService.MODE_SIXTY;
        return MonitorService.MODE_ECO;
    }

    private void saveSettings() {
        thresholdSec = clamp(readInt(thresholdInput, 180), 1, 999);
        amplitude = clamp(readInt(amplitudeInput, 255), 1, 255);
        intervalSec = clamp(readInt(intervalInput, 3), 1, 30);
        mode = selectedMode();
        prefs.edit()
                .putInt(KEY_MODE, mode)
                .putInt(KEY_THRESHOLD, thresholdSec)
                .putInt(KEY_AMPLITUDE, amplitude)
                .putInt(KEY_INTERVAL, intervalSec)
                .apply();
    }

    private void startMonitor() {
        saveSettings();
        Intent intent = new Intent(this, MonitorService.class);
        intent.setAction(MonitorService.ACTION_START);
        startForegroundService(intent);
        MonitorService.RUNNING = true;
        prefs.edit().putBoolean(KEY_RUNNING, true).apply();
        updateRunningUi();
        Toast.makeText(this, "监测已开启", Toast.LENGTH_SHORT).show();
    }

    private void stopMonitor() {
        stopService(new Intent(this, MonitorService.class));
        MonitorService.RUNNING = false;
        prefs.edit().putBoolean(KEY_RUNNING, false).apply();
        updateRunningUi();
        Toast.makeText(this, "监测已关闭", Toast.LENGTH_SHORT).show();
    }

    private void restartMonitor() {
        // The service is already running. Sending START again reloads the
        // preferences in onStartCommand() and resets the detector without a
        // stop/start race that could clobber the running flag in onDestroy().
        Intent intent = new Intent(this, MonitorService.class);
        intent.setAction(MonitorService.ACTION_START);
        startForegroundService(intent);
        MonitorService.RUNNING = true;
        prefs.edit().putBoolean(KEY_RUNNING, true).apply();
        updateRunningUi();
    }

    private void updateRunningUi() {
        boolean running = MonitorService.RUNNING;
        if (running) {
            statusView.setText("已开启");
            statusView.setTextColor(Color.parseColor("#69F0AE"));
            startButton.setText("已开启");
            startButton.setEnabled(false);
            stopButton.setEnabled(true);
        } else {
            statusView.setText("已关闭");
            statusView.setTextColor(Color.parseColor("#90A4AE"));
            startButton.setText("开启监测");
            startButton.setEnabled(true);
            stopButton.setEnabled(false);
        }
    }

    private RadioButton makeMode(String text, int id) {
        RadioButton rb = new RadioButton(this);
        rb.setText(text);
        rb.setId(id);
        rb.setTextSize(14f);
        rb.setTextColor(Color.WHITE);
        rb.setPadding(6, 2, 6, 2);
        return rb;
    }

    private TextView makeLabel(String text, float size, int color) {
        TextView tv = new TextView(this);
        tv.setText(text);
        tv.setTextSize(size);
        tv.setTextColor(color);
        return tv;
    }

    private EditText makeInput(LinearLayout parent, String label, int value, int id) {
        TextView tv = makeLabel(label, 14f, Color.parseColor("#B0BEC5"));
        tv.setPadding(0, 10, 0, 2);
        add(parent, tv);
        if (id == ID_THRESHOLD) thresholdLabel = tv;

        EditText input = new EditText(this);
        input.setId(id);
        input.setText(String.valueOf(value));
        input.setInputType(InputType.TYPE_CLASS_NUMBER);
        input.setSingleLine(true);
        input.setTextSize(18f);
        input.setTextColor(Color.WHITE);
        input.setGravity(Gravity.CENTER);
        input.setBackgroundColor(Color.parseColor("#1A1A1A"));
        input.setPadding(8, 6, 8, 6);
        add(parent, input);
        return input;
    }

    private Button makeButton(String text, int id, int color) {
        Button button = new Button(this);
        button.setText(text);
        button.setId(id);
        button.setTextSize(15f);
        button.setTextColor(Color.WHITE);
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(color);
        bg.setCornerRadius(24f);
        button.setBackground(bg);
        button.setPadding(24, 10, 24, 10);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.setMargins(0, 6, 0, 6);
        button.setLayoutParams(lp);
        return button;
    }

    private void add(LinearLayout parent, View child) {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.setMargins(0, 2, 0, 2);
        parent.addView(child, lp);
    }

    private int readInt(EditText input, int fallback) {
        try {
            return Integer.parseInt(input.getText().toString().trim());
        } catch (Exception e) {
            return fallback;
        }
    }

    private int clamp(int value, int min, int max) {
        if (value < min) return min;
        if (value > max) return max;
        return value;
    }
}

package com.example.vibrate5s;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.PowerManager;
import android.os.SystemClock;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.os.VibratorManager;

public class MonitorService extends Service {

    public static final int MODE_ECO = 0;
    public static final int MODE_LOW = 1;
    public static final int MODE_HIGH = 2;
    public static final int MODE_MAX = 3;
    public static final int MODE_SIXTY = 4;
    public static volatile boolean RUNNING = false;

    public static final String ACTION_START = "com.example.vibrate5s.action.START";
    public static final String ACTION_STOP = "com.example.vibrate5s.action.STOP";
    public static final String ACTION_SAMPLE = "com.example.vibrate5s.action.SAMPLE";
    public static final String ACTION_ALARM = "com.example.vibrate5s.action.ALARM";

    private static final long CONFIRM_MS = 30000L;
    private static final long SAMPLE_MS = 2000L;
    private static final long VIBRATE_MS = 800L;

    // Hidden platform constants, not present in the public android.jar.
    private static final int TYPE_DEVICE_ORIENTATION = 27;
    private static final int TYPE_WRIST_TILT_GESTURE = 26;

    private SharedPreferences prefs;
    private int mode = MODE_ECO;
    private int thresholdSec = 180;
    private int amplitude = 255;
    private int intervalSec = 3;

    private long thresholdMs = 180000L;
    private long intervalMs = 3000L;
    private long sampleIntervalMs = 30000L;

    private SensorManager sensorManager;
    private Sensor accelerometer;
    private Sensor orientationSensor;
    private Sensor wristSensor;
    private Vibrator vibrator;
    private PowerManager.WakeLock wakeLock;
    private AlarmManager alarmManager;
    private PendingIntent alarmIntent;
    private PendingIntent sampleIntent;
    private PendingIntent showIntent;
    private Handler handler;
    private SensorEventListener listener;

    private Runnable pulseRunnable;
    private Runnable sampleFinishRunnable;
    private Runnable confirmFinishRunnable;
    private Runnable maxCheckRunnable;

    private long lastMovement;
    private long alarmGraceUntil;
    private boolean sampling;
    private boolean confirming;
    private boolean alarmActive;
    private boolean baseLock;

    @Override
    public void onCreate() {
        super.onCreate();
        RUNNING = true;
        prefs = getSharedPreferences(MainActivity.PREFS, MODE_PRIVATE);
        startInForeground();

        PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
        wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "NDZ:Alarm");
        wakeLock.setReferenceCounted(false);

        handler = new Handler(Looper.getMainLooper());
        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        orientationSensor = findSensor(TYPE_DEVICE_ORIENTATION);
        wristSensor = findSensor(TYPE_WRIST_TILT_GESTURE);
        alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);

        if (Build.VERSION.SDK_INT >= 31) {
            VibratorManager vm = (VibratorManager) getSystemService(Context.VIBRATOR_MANAGER_SERVICE);
            vibrator = vm.getDefaultVibrator();
        } else {
            vibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
        }

        listener = new SensorEventListener() {
            @Override
            public void onSensorChanged(SensorEvent event) {
                if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
                    float[] v = event.values;
                    float sq = v[0] * v[0] + v[1] * v[1] + v[2] * v[2];
                    if (sq > 110.0f || sq < 80.0f) {
                        onMovement();
                    }
                } else {
                    onMovement();
                }
            }

            @Override
            public void onAccuracyChanged(Sensor sensor, int accuracy) {
            }
        };

        pulseRunnable = new Runnable() {
            @Override
            public void run() {
                if (!alarmActive) return;
                long now = SystemClock.elapsedRealtime();
                alarmGraceUntil = now + Math.min(1000L, Math.max(300L, intervalMs / 2));
                vibrateOnce();
                handler.postDelayed(this, intervalMs);
            }
        };

        sampleFinishRunnable = new Runnable() {
            @Override
            public void run() {
                finishSample();
            }
        };

        confirmFinishRunnable = new Runnable() {
            @Override
            public void run() {
                finishConfirmation();
            }
        };

        maxCheckRunnable = new Runnable() {
            @Override
            public void run() {
                if (mode != MODE_MAX || alarmActive || confirming) return;
                long now = SystemClock.elapsedRealtime();
                if (now - lastMovement >= thresholdMs) {
                    beginConfirmation();
                } else {
                    handler.postDelayed(this, 1000L);
                }
            }
        };

        Intent alarm = new Intent(this, MonitorService.class).setAction(ACTION_ALARM);
        alarmIntent = PendingIntent.getForegroundService(this, 1, alarm,
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        Intent sample = new Intent(this, MonitorService.class).setAction(ACTION_SAMPLE);
        sampleIntent = PendingIntent.getForegroundService(this, 2, sample,
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        Intent show = new Intent(this, MainActivity.class);
        showIntent = PendingIntent.getActivity(this, 3, show,
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        prefs.edit().putBoolean(MainActivity.KEY_RUNNING, true).apply();
        lastMovement = SystemClock.elapsedRealtime();
        reloadSettings();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        reloadSettings();
        String action = intent == null ? null : intent.getAction();
        if (ACTION_STOP.equals(action)) {
            stopSelf();
            return START_NOT_STICKY;
        }
        if (ACTION_SAMPLE.equals(action)) {
            handleSampleAlarm();
            return START_STICKY;
        }
        if (ACTION_ALARM.equals(action)) {
            handleAlarm();
            return START_STICKY;
        }
        startMonitoring();
        return START_STICKY;
    }

    private void startInForeground() {
        if (Build.VERSION.SDK_INT >= 26) {
            NotificationChannel channel = new NotificationChannel(
                    "ndz", "NDZ", NotificationManager.IMPORTANCE_LOW);
            NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            nm.createNotificationChannel(channel);
        }
        Intent show = new Intent(this, MainActivity.class);
        PendingIntent pi = PendingIntent.getActivity(this, 3, show,
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        Notification.Builder b;
        if (Build.VERSION.SDK_INT >= 26) {
            b = new Notification.Builder(this, "ndz");
        } else {
            b = new Notification.Builder(this);
        }
        b.setContentTitle("NDZ · 监测中")
                .setContentText("静止提醒正在运行")
                .setSmallIcon(android.R.drawable.stat_notify_sync)
                .setContentIntent(pi)
                .setOngoing(true);
        startForeground(1, b.build());
    }

    private Sensor findSensor(int type) {
        if (sensorManager == null) return null;
        Sensor s = sensorManager.getDefaultSensor(type);
        if (s != null) return s;
        java.util.List<Sensor> list = sensorManager.getSensorList(type);
        if (list != null && !list.isEmpty()) return list.get(0);
        return null;
    }

    private void reloadSettings() {
        mode = prefs.getInt(MainActivity.KEY_MODE, MODE_ECO);
        thresholdSec = prefs.getInt(MainActivity.KEY_THRESHOLD, 180);
        amplitude = prefs.getInt(MainActivity.KEY_AMPLITUDE, 255);
        intervalSec = prefs.getInt(MainActivity.KEY_INTERVAL, 3);
        // Eco uses the user's threshold. The three fixed strategies encode
        // their latency in the mode: Low waits 30s, High 15s, Max 0s before
        // the common 30s confirmation window.
        if (mode == MODE_LOW) {
            thresholdMs = 30000L;
        } else if (mode == MODE_HIGH) {
            thresholdMs = 15000L;
        } else if (mode == MODE_SIXTY) {
            thresholdMs = 60000L;
        } else if (mode == MODE_MAX) {
            thresholdMs = 0L;
        } else {
            thresholdMs = Math.max(1, thresholdSec) * 1000L;
        }
        intervalMs = intervalSec * 1000L;
        if (mode == MODE_SIXTY) {
            sampleIntervalMs = 60000L;
        } else if (mode == MODE_LOW) {
            sampleIntervalMs = 30000L;
        } else {
            sampleIntervalMs = 15000L;
        }
    }

    private void startMonitoring() {
        reloadSettings();
        cancelAll();
        releaseLock(true);
        baseLock = false;

        lastMovement = SystemClock.elapsedRealtime();
        if (mode == MODE_ECO) {
            register(orientationSensor, SensorManager.SENSOR_DELAY_NORMAL);
            register(wristSensor, SensorManager.SENSOR_DELAY_NORMAL);
            scheduleThresholdAlarm();
        } else if (mode == MODE_LOW || mode == MODE_HIGH || mode == MODE_SIXTY) {
            scheduleSample(sampleIntervalMs);
        } else {
            acquireLock();
            baseLock = true;
            register(accelerometer, SensorManager.SENSOR_DELAY_NORMAL);
            handler.postDelayed(maxCheckRunnable, 1000L);
        }
    }

    private void handleSampleAlarm() {
        if (mode != MODE_LOW && mode != MODE_HIGH && mode != MODE_SIXTY) return;
        if (sampling || confirming || alarmActive) return;
        sampling = true;
        acquireLockFor(5000L);
        register(accelerometer, SensorManager.SENSOR_DELAY_NORMAL);
        handler.postDelayed(sampleFinishRunnable, SAMPLE_MS);
    }

    private void finishSample() {
        if (!sampling) return;
        sampling = false;
        unregisterAll();
        releaseLock(false);
        if (SystemClock.elapsedRealtime() - lastMovement >= thresholdMs) {
            beginConfirmation();
        } else {
            scheduleSample(sampleIntervalMs);
        }
    }

    private void handleAlarm() {
        if (mode == MODE_ECO && !confirming && !alarmActive) {
            beginConfirmation();
        }
    }

    private void beginConfirmation() {
        if (confirming || alarmActive) return;
        confirming = true;
        cancelAll();
        unregisterAll();
        if (!baseLock) acquireLockFor(40000L);
        register(accelerometer, SensorManager.SENSOR_DELAY_NORMAL);
        handler.postDelayed(confirmFinishRunnable, CONFIRM_MS);
    }

    private void finishConfirmation() {
        if (!confirming) return;
        confirming = false;
        unregisterAll();
        if (!baseLock) releaseLock(false);
        if (SystemClock.elapsedRealtime() - lastMovement >= thresholdMs) {
            startAlarm();
        } else {
            resumeDetection();
        }
    }

    private void onMovement() {
        long now = SystemClock.elapsedRealtime();
        if (alarmActive && now < alarmGraceUntil) return;
        lastMovement = now;
        if (alarmActive) {
            stopAlarm();
            resumeDetection();
        } else if (confirming) {
            confirming = false;
            handler.removeCallbacks(confirmFinishRunnable);
            unregisterAll();
            if (!baseLock) releaseLock(false);
            resumeDetection();
        } else if (mode == MODE_ECO) {
            scheduleThresholdAlarm();
        }
    }

    private void resumeDetection() {
        if (mode == MODE_ECO) {
            register(orientationSensor, SensorManager.SENSOR_DELAY_NORMAL);
            register(wristSensor, SensorManager.SENSOR_DELAY_NORMAL);
            scheduleThresholdAlarm();
        } else if (mode == MODE_LOW || mode == MODE_HIGH || mode == MODE_SIXTY) {
            scheduleSample(sampleIntervalMs);
        } else {
            if (!baseLock) {
                acquireLock();
                baseLock = true;
            }
            register(accelerometer, SensorManager.SENSOR_DELAY_NORMAL);
            handler.removeCallbacks(maxCheckRunnable);
            handler.postDelayed(maxCheckRunnable, 1000L);
        }
    }

    private void startAlarm() {
        confirming = false;
        cancelAll();
        alarmActive = true;
        alarmGraceUntil = SystemClock.elapsedRealtime() + 2000L;
        acquireLock();
        // Keep a movement listener alive while the alarm is firing.  Use the
        // wrist/orientation wake-up sensors, not the accelerometer: vibration
        // can move the accelerometer enough to look like a false "movement".
        register(orientationSensor, SensorManager.SENSOR_DELAY_NORMAL);
        register(wristSensor, SensorManager.SENSOR_DELAY_NORMAL);
        vibrateOnce();
        handler.removeCallbacks(pulseRunnable);
        handler.postDelayed(pulseRunnable, intervalMs);
    }

    private void stopAlarm() {
        alarmActive = false;
        alarmGraceUntil = 0L;
        handler.removeCallbacks(pulseRunnable);
        unregisterAll();
        if (!baseLock) releaseLock(false);
    }

    private void scheduleThresholdAlarm() {
        if (alarmManager == null || alarmIntent == null) return;
        alarmManager.cancel(alarmIntent);
        long trigger = System.currentTimeMillis() + thresholdMs;
        AlarmManager.AlarmClockInfo info = new AlarmManager.AlarmClockInfo(trigger, showIntent);
        alarmManager.setAlarmClock(info, alarmIntent);
    }

    private void scheduleSample(long delayMs) {
        if (alarmManager == null || sampleIntent == null) return;
        alarmManager.cancel(sampleIntent);
        long trigger = System.currentTimeMillis() + delayMs;
        if (Build.VERSION.SDK_INT >= 23) {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, trigger, sampleIntent);
        } else {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, trigger, sampleIntent);
        }
    }

    private void acquireLock() {
        if (wakeLock != null && !wakeLock.isHeld()) {
            wakeLock.acquire();
        }
    }

    private void acquireLockFor(long timeoutMs) {
        if (wakeLock != null && !wakeLock.isHeld()) {
            wakeLock.acquire(timeoutMs);
        }
    }

    private void releaseLock(boolean force) {
        if (wakeLock != null && wakeLock.isHeld() && (force || !baseLock)) {
            wakeLock.release();
        }
    }

    private void register(Sensor sensor, int delay) {
        if (sensorManager != null && sensor != null && listener != null) {
            sensorManager.registerListener(listener, sensor, delay, handler);
        }
    }

    private void unregisterAll() {
        if (sensorManager != null && listener != null) {
            sensorManager.unregisterListener(listener);
        }
    }

    private void cancelAll() {
        if (alarmManager != null) {
            if (alarmIntent != null) alarmManager.cancel(alarmIntent);
            if (sampleIntent != null) alarmManager.cancel(sampleIntent);
        }
        if (handler != null) {
            handler.removeCallbacks(sampleFinishRunnable);
            handler.removeCallbacks(confirmFinishRunnable);
            handler.removeCallbacks(maxCheckRunnable);
            handler.removeCallbacks(pulseRunnable);
        }
    }

    private void vibrateOnce() {
        if (vibrator == null || !vibrator.hasVibrator()) return;
        if (Build.VERSION.SDK_INT >= 26) {
            vibrator.vibrate(VibrationEffect.createOneShot(VIBRATE_MS, amplitude));
        } else {
            vibrator.vibrate(VIBRATE_MS);
        }
    }

    @Override
    public void onDestroy() {
        RUNNING = false;
        prefs.edit().putBoolean(MainActivity.KEY_RUNNING, false).apply();
        cancelAll();
        unregisterAll();
        baseLock = false;
        releaseLock(true);
        stopForeground(true);
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}

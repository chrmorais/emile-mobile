package gsort.pos.engsisubiq.EmileMobile;

import java.util.Map;
import java.util.Random;
import android.R;
import android.util.Log;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.content.Intent;
import android.content.Context;
import android.content.res.Resources;
import android.provider.Settings;
import android.provider.Settings.System;
import android.app.Notification;
import android.app.PendingIntent;
import android.app.NotificationManager;
import com.google.firebase.messaging.RemoteMessage;
import com.google.firebase.messaging.FirebaseMessagingService;

import org.json.JSONObject;

public class FirebaseListenerService extends FirebaseMessagingService
{
    private boolean debug = true;

    public FirebaseListenerService()
    {
        super();
    }

    /**
     * Called when message is received and app is running (background or foreground).
     *
     * @param from SenderID of the sender.
     * @param data Data bundle containing message data as key/value pairs.
     *             For Set of keys use data.keySet().
     */
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage)
    {
        RemoteMessage.Notification notification = remoteMessage.getNotification();
        Map<String,String> map = remoteMessage.getData();
        if (debug) {
            Log.i("FirebaseListenerService", "Look for all keys in the map:");
            for (String key : map.keySet())
                Log.i("FirebaseListenerService", key + ": " + map.get(key));
            Log.i("FirebaseListenerService", "the messageData is: " + map.get("sender"));
        }
        if (map.get("body") != null)
            map.put("message", map.get("body"));
        if (notification != null) {
            if (notification.getTitle() != null && map.get("title") == null)
                map.put("title", notification.getTitle());
            if (notification.getBody() != null)
                map.put("message", notification.getBody());
        }
        sendNotification(map.get("title"), map.get("message"), map.get("sender"));
        map.clear();
        map = null;
    }

    public void sendNotification(String title, String message, String messageData)
    {
        JSONObject jObject = null;
        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        Notification.Builder notificationBuilder = new Notification.Builder(this);
        // play default notification sound and start alert led(if available)
        notificationBuilder.setSound(Settings.System.DEFAULT_NOTIFICATION_URI).setLights(Color.RED, 3000, 3000);
        // start vibration if user configured app to vibrate
        notificationBuilder.setVibrate(new long[] {500, 500, 500});
        // to start LED
        notificationBuilder.setLights(Color.RED, 3000, 3000);
        // each notification needs to have a unique ID, for that can be grouped one below the other
        // if the ID is not sent (like local notification) we need generate a random ID
        Random random = new Random();
        int messageId = random.nextInt(9999-1000) + 1000;

        Intent intent = new Intent(this, CustomActivity.class);
        intent.putExtra("messageData", messageData);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);

        // create pending intent, mention the Activity which needs to be
        // triggered when user clicks on notification
        PendingIntent contentIntent = PendingIntent.getActivity(this, messageId, intent, PendingIntent.FLAG_ONE_SHOT);
        notificationBuilder.setAutoCancel(true)
        .setContentTitle(title)
        .setContentText(message)
        .setContentIntent(contentIntent)
        .setDefaults(Notification.DEFAULT_SOUND);

        try {
            jObject = new JSONObject(messageData);
        } catch(Exception e) { }

        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            // add app transparent icon
            notificationBuilder.setColor(0x222222);
            notificationBuilder.setGroupSummary(true);
            notificationBuilder.setSmallIcon(android.R.drawable.star_on);
            notificationBuilder.setGroup(FirebaseListenerService.class.getSimpleName()+CustomActivity.class);

            Notification.BigTextStyle bigText = new Notification.BigTextStyle();
            bigText.bigText(message);
            bigText.setBigContentTitle(title);
            String sumaryText = "";
            try {
                sumaryText = jObject.getString("name");
            } catch(Exception e) { }
            bigText.setSummaryText(":: " + sumaryText);
            notificationBuilder.setStyle(bigText);
        } else {
            // add app icon
            notificationBuilder.setSmallIcon(android.R.drawable.star_on);
        }
        notificationManager.notify(messageId, notificationBuilder.build());
        if (!messageData.equals(""))
            ActivityToApplication.pushNotificationNotify(messageData);
    }
}

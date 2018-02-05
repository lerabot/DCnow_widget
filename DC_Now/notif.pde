import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Color;

import   android.app.Notification;
import   android.support.v7.app.NotificationCompat;
//import   java.lang.Object;

String channelID = "dc_notif";

void createManager() {
  NotificationManager mNotificationManager = (NotificationManager) getActivity().getSystemService(Context.NOTIFICATION_SERVICE);
  // The id of the channel.
  String id = channelID;
  // The user-visible name of the channel.
  CharSequence name = "DC-now channel";
  // The user-visible description of the channel.
  String description = "??";
  int importance = NotificationManager.IMPORTANCE_HIGH;
  NotificationChannel mChannel = new NotificationChannel(id, name, importance);
  // Configure the notification channel.
  mChannel.setDescription("wow");
  mChannel.setDescription(description);
  mChannel.enableLights(true);
  // Sets the notification light color for notifications posted to this
  // channel, if the device supports this feature.
  //mChannel.setLightColor(Color.RED);
  mChannel.enableVibration(true);
  mChannel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});
  mNotificationManager.createNotificationChannel(mChannel);
}


//void setNotif(String text) {
//          public Notification.Builder getAndroidChannelNotification(String title, String body) {
//          return new Notification.Builder(getApplicationContext(), ANDROID_CHANNEL_ID)
//            .setContentTitle(title)
//            .setContentText(body)
//            .setSmallIcon(android.R.drawable.stat_notify_more)
//            .setAutoCancel(true);
//}
          
//                .setChannelId(channelID)
//                //.setContentTitle(getPackageName())
//                .setContentText(text)
//                //.setBadgeIconType(R.mipmap.ic_launcher)
//                //.setNumber(5)
//                //.setSmallIcon(R.mipmap.ic_launcher_round)
//                .setAutoCancel(true)
//                .build();
          
//}
//*/
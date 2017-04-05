package gsort.pos.engsisubiq.EmileMobile;

import android.util.Log;
import android.os.Bundle;
import android.content.Intent;

public class CustomActivity extends org.qtproject.qt5.android.bindings.QtActivity
{
    public CustomActivity()
    {
        super();
    }

    public void minimize()
    {
        moveTaskToBack(true);
    }

    @Override
    protected void onNewIntent(Intent intent)
    {
        super.onNewIntent(intent);
        Bundle bundle = intent.getExtras();
        if (bundle != null) {
            String notificationData = bundle.getString("messageData");
            Log.i("CustomActivity", "onNewIntent(Intent intent)");
            Log.i("CustomActivity", "notificationData: " + notificationData);
            // adicionar aqui a passagem dos dados para o app
            // CustomQtActivity.setPushNotificationArgs(bundle.getString("actionType"), bundle.getString("actionTypeId"));
        }
    }
}

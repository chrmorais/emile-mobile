package gsort.pos.engsisubiq.EmileMobile;

import android.content.Intent;

public class CustomActivity extends org.qtproject.qt5.android.bindings.QtActivity
{
    public CustomActivity()
    {
        super();
    }

    @Override
    public void onResume()
    {
        super.onResume();
        startPushNotificationCheck();
    }

    @Override
    protected void onNewIntent(Intent intent)
    {
        super.onNewIntent(intent);
        android.os.Bundle bundle = intent.getExtras();
        if (bundle != null) {
            String messageData = bundle.getString("messageData");
            if (!messageData.equals(""))
                ActivityToApplication.pushNotificationNotify(messageData);
        }
    }

    private void startPushNotificationCheck()
    {
        java.lang.Thread t = new java.lang.Thread(new Runnable()
        {
            @Override
            public void run()
            {
                try  {
                    PushNotificationTokenParse pNTP = new PushNotificationTokenParse(getApplicationContext());
                    pNTP.checkToken();
                } catch (Exception e) { }
            }
        });
        t.start();
    }

    public void minimize()
    {
        moveTaskToBack(true);
    }
}

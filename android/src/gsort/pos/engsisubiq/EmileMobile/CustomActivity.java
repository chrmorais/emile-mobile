package gsort.pos.engsisubiq.EmileMobile;

import android.os.Build;
import android.os.Bundle;
import android.graphics.Color;
import android.content.Intent;
import android.view.Window;
import android.view.WindowManager;

public class CustomActivity extends org.qtproject.qt5.android.bindings.QtActivity
{
    public CustomActivity()
    {
        super();
    }

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window w = getWindow();
            w.setFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS, WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
            w.setFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS, WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            w.setStatusBarColor(Color.TRANSPARENT);
        }
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

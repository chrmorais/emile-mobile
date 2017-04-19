package gsort.pos.engsisubiq.EmileMobile;

import android.util.Log;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageManager.NameNotFoundException;
import com.google.firebase.iid.FirebaseInstanceId;

public class PushNotificationTokenParse
{
    private Context context;
    private String packageName;
    private SharedPreferences sharedPreferences;

    public PushNotificationTokenParse(Context ctxt)
    {
        context = ctxt;
        packageName = context.getPackageName();
        sharedPreferences = context.getSharedPreferences(packageName, Context.MODE_PRIVATE);
    }

    public void checkToken()
    {
        int appVersion = 0;
        String savedToken = "";

        savedToken = sharedPreferences.getString("push_notification_token_id", "");
        appVersion = Integer.parseInt(sharedPreferences.getString("app_version_registered", "0"));

        if (savedToken.equals("") || appVersion != getAppVersion()) {
            String newToken = FirebaseInstanceId.getInstance().getToken();
            if (newToken.equals("") == false && savedToken.equals(newToken) == false ) {
                registerToken(savedToken);
                notifyApplication(savedToken);
            }
        }
    }

    public void registerToken(String token)
    {
        int appVersion = getAppVersion();
        SharedPreferences.Editor prefsEditor = sharedPreferences.edit();
        prefsEditor.putString("app_version_registered", Integer.toString(appVersion));
        prefsEditor.putString("push_notification_token_id", token);
        prefsEditor.apply();
    }

    public void notifyApplication(String token)
    {
        ActivityToApplication.eventNotify("push_notification_token", token);
    }

    private int getAppVersion()
    {
        int appVersion = 0;
        try {
            appVersion = context.getPackageManager().getPackageInfo(packageName,0).versionCode;
        } catch(NameNotFoundException e) { }
        return appVersion;
    }
}

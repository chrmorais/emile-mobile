package gsort.pos.engsisubiq.EmileMobile;

import android.util.Log;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageManager.NameNotFoundException;

import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.FirebaseInstanceIdService;

public class FirebaseInstanceIDListenerService extends FirebaseInstanceIdService
{
    private boolean debug = true;
    private static SharedPreferences sharedPreferences;

    public FirebaseInstanceIDListenerService()
    {
        super();
    }

    /**
     * Called when the Firebase ID Token is created or when is updated.
     * This may occur if the security of the previous token had been compromised.
     * This call is initiated by the InstanceID provider.
     */
    @Override
    public void onTokenRefresh()
    {
        // Fetch updated Instance ID token and notify our app's server of any changes
        String token = FirebaseInstanceId.getInstance().getToken();

        if (debug) {
            Log.i("FirebaseInstanceIDListenerService", "onTokenRefresh() called!");
            Log.i("FirebaseInstanceIDListenerService", "token registered is: " + token);
        }

        Context context = getApplicationContext();
        sharedPreferences = context.getSharedPreferences(context.getPackageName(), Context.MODE_PRIVATE);

        int appVersion = 0;

        try {
            appVersion = context.getPackageManager().getPackageInfo(getPackageName(),0).versionCode;
        } catch(NameNotFoundException e) {
            if (debug)
                Log.i("FirebaseInstanceIDListenerService", e.getMessage());
            return;
        }

        // store the token in app database with current app version
        SharedPreferences.Editor prefsEditor = sharedPreferences.edit();
        prefsEditor.putString("app_version_registered", Integer.toString(appVersion));
        prefsEditor.putString("push_notification_token_id", token);
        prefsEditor.apply();

        TokenToApplication.notifyTokenUpdate(token);
    }
} //end

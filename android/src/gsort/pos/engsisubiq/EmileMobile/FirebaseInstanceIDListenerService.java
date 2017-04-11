package gsort.pos.engsisubiq.EmileMobile;

import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.FirebaseInstanceIdService;

public class FirebaseInstanceIDListenerService extends FirebaseInstanceIdService
{
    private boolean debug = true;

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
            android.util.Log.i("FirebaseInstanceIDListenerService", "onTokenRefresh() called!");
            android.util.Log.i("FirebaseInstanceIDListenerService", "token registered is: " + token);
        }
        if (!token.equals("")) {
            PushNotificationTokenParse pNTP = new PushNotificationTokenParse(getApplicationContext());
            pNTP.registerToken(token);
            pNTP.notifyApplication(token);
        }
    }
} //end

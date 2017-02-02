#import "Firebase.h"
#import <UIKit/UIKit.h>
#import <QString>
#include <QtCore>
#include "../cpp/pushnotificationtokenlistener.h"

@interface QIOSApplicationDelegate
@end

@interface QIOSApplicationDelegate(QtAppDelegate)
@end

@implementation QIOSApplicationDelegate (QtAppDelegate)

LocationManager * shareModel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configFirebase];
    NSLog(@"Firebase connect start!");
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Firebase disconnect!");
    NSLog(@"enter in applicationDidEnterBackground method");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self connectToFcm];
    NSLog(@"Conectou com o FCM");

    [shareModel startMonitoringLocation];

    NSLog(@"enter in applicationDidBecomeActive method");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"enter in applicationWillTerminate method");
}

- (void)applicationWillResignActive:(UIApplication *)application{
     NSLog(@"enter in applicationWillResignActive method");
}
-(void)configFirebase {
    // iOS 8 or later
    // [START register_for_notifications]
    UIUserNotificationType allNotificationTypes =  (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    // [END register_for_notifications]

    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]

    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDTokenRefreshNotification object:nil];

    NSLog(@"Configurando Firebase ");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
  fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    UIApplicationState state = [application applicationState];
    if (state != UIApplicationStateActive) {
         // NotificationClient::setPushNotificationArgs(QString::fromNSString(userInfo[@"gcm.notification.actionType"]), QString::fromNSString(userInfo[@"gcm.notification.actionTypeId"]));
         // só notifica se o app estiver inativo em background
     }
     /*
          NSString *showTitle = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"title"];
          //NSString *msg = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"body"];
          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Você recebeu uma nova notificação"
                                                                                   message:showTitle
                                                                            preferredStyle:UIAlertControllerStyleAlert];
          //We add buttons to the alert controller by creating UIAlertActions:
          UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                             style:UIAlertActionStyleDefault
                                                           handler:nil]; //You can use a block here to handle a press on this button
          [alertController addAction:actionOk];
          UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
          [rootViewController presentViewController:alertController animated:YES completion:nil];
      } else {
        //Do stuff that you would do if the application was not active
        NotificationClient::setPushNotificationArgs(QString::fromNSString(userInfo[@"gcm.notification.actionType"]), QString::fromNSString(userInfo[@"gcm.notification.actionTypeId"]));
      }
*/
     //NotificationClient::setPushNotificationArgs(QString::fromNSString(userInfo[@"gcm.notification.actionType"]), QString::fromNSString(userInfo[@"gcm.notification.actionTypeId"]));
     //NSLog(@"Mensagem: %@", userInfo);
    //NSLog(@"actionType: %@", userInfo[@"gcm.notification.actionType"]);
    //NSLog(@"actionTypeId: %@", userInfo[@"gcm.notification.actionTypeId"]);
}

- (void)tokenRefreshNotification:(NSNotification *)notification {

    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"Token updated: %@", refreshedToken);

    PushNotificationTokenListener::tokenUpdateNotify(QString::fromNSString(refreshedToken));

    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil)
            NSLog(@"Unable to connect to FCM. %@", error);
        else
            NSLog(@"Conectou com o FCM.");
    }];
}
@end

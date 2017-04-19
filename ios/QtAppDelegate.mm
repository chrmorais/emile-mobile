#include "Firebase/Firebase.h"
#import <UIKit/UIKit.h>

#include <QString>
#include <QtCore>
#include "../cpp/emile.h"

@interface QIOSApplicationDelegate
@end
@interface QIOSApplicationDelegate(QtAppDelegate)
@end

@implementation QIOSApplicationDelegate (QtAppDelegate)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    Q_UNUSED(application)
    Q_UNUSED(launchOptions)

    [self configFirebase];
    NSLog(@"Firebase connect start!");
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    Q_UNUSED(application)
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Firebase disconnect!");
    NSLog(@"enter in applicationDidEnterBackground method");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    Q_UNUSED(application)
    // Restart any tasks that were paused (or not yet started) while the application was inactive.
    // If the application was previously in the background, optionally refresh the user interface.
    [self connectToFcm];
    NSLog(@"Conectou com o FCM");
    NSLog(@"enter in applicationDidBecomeActive method");

    // clear the app icon badge with notification count
    // http://stackoverflow.com/questions/27311910/how-to-clear-badge-counter-on-click-of-app-icon-in-iphone
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    Q_UNUSED(application)
    NSLog(@"enter in applicationWillTerminate method");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    Q_UNUSED(application)
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

    NSLog(@"Configurando Firebase...");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
  fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    UIApplicationState state = [application applicationState];
    NSLog(@"Nova mensagem do firebase");

    NSString *title = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"title"];
    NSString *message = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"body"];

    if (state != UIApplicationStateActive)
        Emile::appNativeEventNotify("new_push_message", QString::fromNSString(userInfo[@"gcm.notification.messageData"]));

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
            message:message
            preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
            style:UIAlertActionStyleDefault
            handler:nil]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    [rootViewController presentViewController:alertController animated:YES completion:nil];
    Emile::appNativeEventNotify("new_push_message", QString::fromNSString(message));
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    Q_UNUSED(notification)
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"Ops! The token was updated: %@", refreshedToken);

    Emile::appNativeEventNotify("push_notification_token", QString::fromNSString(refreshedToken));

    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
}

- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil)
            NSLog(@"Unable to connect to FCM. %@", error);
        else
            NSLog(@"Conectou com o FCM.");
    }];
}

+ (BOOL)notificationServicesEnabled {
    BOOL isEnabled = NO;

    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {

        UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];

        if (!notificationSettings || (notificationSettings.types == UIUserNotificationTypeNone))
            isEnabled = NO;
        else
            isEnabled = YES;
        
    } else {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isEnabled = (types & UIRemoteNotificationTypeAlert);
    }

    return isEnabled;
}
@end

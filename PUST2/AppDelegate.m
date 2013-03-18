//
//  AppDelegate.m
//  PUST2
//
//  Created by cetauri on 13. 3. 15..
//  Copyright (c) 2013년 KT. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import <baas.io/Baas.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Baasio setApplicationInfo:@"cetauri" applicationName:@"befe"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    NSError *e;
    [BaasioUser signIn:@"cetauri" password:@"cetauri" error:&e];
    NSLog(@"e : %@", e.localizedDescription);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];

    return YES;
}

#pragma mark -
#pragma mark Apple Push Notifications
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// didFinishLaunchingWithOptions를 구현할 경우 사용되지 않는다.
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

// 애플리케이션 실행 중에 RemoteNotification 을 수신
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //	NSLog(@"1. didReceiveRemoteNotification");
	// push 메시지 추출
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    
	application.applicationIconBadgeNumber = [[aps objectForKey:@"badge"] intValue];
	
    // alert 추출
    NSString *alertMessage = [aps objectForKey:@"alert"];
	
	NSString *string = [NSString stringWithFormat:@"%@", alertMessage];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:string delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
	[alert show];
}

// APNS 에 RemoteNotification 등록 실패
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
	NSLog(@"Error in registration. Error: %@", error);
}


// RemoteNotification 등록 성공. deviceToken을 수신
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSLog(@"2. didRegisterForRemoteNotificationsWithDeviceToken");
	
	NSMutableString *deviceId = [NSMutableString string];
	const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
	
	for(int i = 0 ; i < 32 ; i++)
	{
		[deviceId appendFormat:@"%02x", ptr[i]];
	}
	
	NSLog(@"This phone's deviceId : %@", deviceId);
    
    BaasioPush *push = [[BaasioPush alloc] init];
    NSArray *tags = @[@"male"];
    
    //ASync
//    [push registerInBackground:deviceId
//                          tags: (NSArray *)tags
//                  successBlock:^(void) {
//                      NSLog(@"baas.io에 device가 등록됨");
//                  }
//                  failureBlock:^(NSError *error) {
//                      NSLog(@"device등록 실패 : %@", error.localizedDescription);
//                  }];

    
    
    //Sync
    NSError *e = nil;
    [push register:deviceId tags:tags error:&e];
    NSLog(@"e : %@", e.localizedDescription);
    
    
	NSLog(@"finish");
}


@end

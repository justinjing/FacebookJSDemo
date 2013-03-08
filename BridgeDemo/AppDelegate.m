//
//  AppDelegate.m
//  BridgeDemo
//
//  Created by  xyh on 12-10-10.
//  Copyright (c) 2012年 xyh. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"


@implementation AppDelegate
@synthesize window;
@synthesize devToken;

//获取当前网络状态
- (void)getAccess_internet_type {
    
    //[[CheckNetwork shareCheckNetwork] currentReachabilityStatus];
}


- (void)dealloc
{
    [devToken release];
    [window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
 
        RootViewController *con = [[RootViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
        nav.navigationBarHidden=YES;
        self.window.rootViewController = nav;
        [con release];
  
    [self.window makeKeyAndVisible];
    [self getAccess_internet_type];
    
    
    return YES;
    //exports.commonUrl = 'http://pamdm.pingan.com.cn/pamdm/oas_meoa/ios/';//'http://10.13.211.0:8001/pamdm/';//'http://pamdm.pingan.com.cn/pamdm/oas_meoa/ios/';
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken: %@", deviceToken);
  
    NSMutableString *token = [NSMutableString stringWithFormat:@"%@", deviceToken];
    [token deleteCharactersInRange:NSMakeRange(0, 1)];
    [token deleteCharactersInRange:NSMakeRange(token.length-1, 1)];
    [token appendFormat:@"-%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
    self.devToken=token;
    //[[PAJSLibrary share] appReceiveKeyAndValue:[RootViewController share]->wb Value:token Key:@"deviceToken"];
    
    
    //客户端基本信息采集
//    [[PAClientCollect share] collectPublishChannel:@"AppStore"];//采集应用发布的渠道，如appstore、安卓市场、平安网站等
//    [[PAClientCollect share] collectDeviceToken:token];//采集设备令牌
//    [[PAClientCollect share] collectBasicOtherInfo:nil];//采集客户端其他的基本信息
//    [[PAClientCollect share] collectBasicInfoBody];
//    [[PAClientCollect share] sendBasicInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
    //客户端基本信息采集
//    [[PAClientCollect share] collectPublishChannel:@"AppStore"];//采集应用发布的渠道，如appstore、安卓市场、平安网站等
//    [[PAClientCollect share] collectDeviceToken:nil];//采集设备令牌
//    [[PAClientCollect share] collectBasicOtherInfo:nil];//采集客户端其他的基本信息
//    [[PAClientCollect share] collectBasicInfoBody];
//    [[PAClientCollect share] sendBasicInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    [[PAJSLibrary share]  sendAPNS:[RootViewController share]->wb APNSMeassge:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
//    [[PAJSLibrary share] requestAPNS:[RootViewController share]->wb]; // 通知后台去拉数据
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

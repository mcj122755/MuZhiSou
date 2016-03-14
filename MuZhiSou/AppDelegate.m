//
//  AppDelegate.m
//  MuZhiSou
//
//  Created by MCJ on 16/1/21.
//  Copyright (c) 2016年 MuZhiSou. All rights reserved.
//

#import "AppDelegate.h"
#import "ZMSTabBarController.h"
#import "RootViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "JPUSHService.h"
#import "SearchViewController.h"

//极光推送appkey 43c41056e3dd28596e3f2226

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 1. 添加第三方分享
    [self addUMengShare];
    
    // 2. 添加极光推送
    [self addJiGuangPush:launchOptions];
    
    // 添加
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)addUMengShare
{
    // 注册
    //  自己的56d4f35867e58e7d82000ee9  友盟的53290df956240b6b4a0084b3
    [UMSocialData setAppKey:@"56d4f35867e58e7d82000ee9"];
    
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx10274c2f23f2b4a2" appSecret:@"b0659aec7c7e4a290b9c96054107841f" url:@"http://wap.muzhiso.com"];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1105221006" appKey:@"GxFoz7hPZGgyLliL" url:@"http://wap.muzhiso.com"];
    
    
    // 打开新浪微博的SSO开关
    // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1518972172" secret:@"1cf4a5cd5de3833846b2a8e9cb4929fc" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

- (void)addJiGuangPush:(NSDictionary *)launchOptions
{
    // 解决ios8 之后接受不到消息
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    } else {
        //categories 必须为nil 兼容低版本
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert) categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:@"43c41056e3dd28596e3f2226" channel:nil apsForProduction:nil];
}

// 通过设备的tocken来注册远程推送通知
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

// 接受远程推送通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

// 接受到远程推送通知之后的回调函数
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}
@end

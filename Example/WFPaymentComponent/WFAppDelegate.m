//
//  WFAppDelegate.m
//  WFPaymentComponent
//
//  Created by wyxlh on 07/18/2019.
//  Copyright (c) 2019 wyxlh. All rights reserved.
//

#import "WFAppDelegate.h"
#import "YKAlipayTool.h"
#import "WFPaymentHelp.h"


@implementation WFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //向微信注册,发起支付必须注册
    [WXApi registerApp:WXAppId enableMTA:YES];
    return YES;
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)applicationOpenURL:(NSURL *)url
{
    if ([[url absoluteString] containsString:@"safepay"]) {
        //支付宝
        [self configureForAliPay:url];
        return NO;
    }else if([[url absoluteString] containsString:WXAppId]){
        //微信支付
        [WXApi handleOpenURL:url delegate:self];
    }else if([[url absoluteString] containsString:@"uppayresult"]){
        return NO;
    }
    return NO;
}

/**
 微信支付的代理
 */
#pragma mark -
-(void) onResp:(BaseResp*)resp{
    
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess: {
                ![YKAlipayTool shareInstance].paySuccess ? : [YKAlipayTool shareInstance].paySuccess();
                break;
            }
                
            default: {
                ![YKAlipayTool shareInstance].payFailed ? : [YKAlipayTool shareInstance].payFailed();
                break;
            }
        }
    }
}

/**
 支付宝支付成功后的回调
 */
#pragma mark -
- (void)configureForAliPay:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            if ([[resultDic objectForKey:@"resultStatus"] intValue]==9000) {
                ![YKAlipayTool shareInstance].paySuccess ? : [YKAlipayTool shareInstance].paySuccess();
            }else{
                ![YKAlipayTool shareInstance].payFailed ? : [YKAlipayTool shareInstance].payFailed();
            }
        }];
    }
}

@end

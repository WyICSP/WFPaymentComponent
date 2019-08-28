//
//  YKAlipayTool.h
//  YukiFramework
//
//  Created by 王宇 on 2018/5/31.
//  Copyright © 2018年 wy. All rights reserved.
//


#import <Foundation/Foundation.h>
//支付宝
#import <AlipaySDK/AlipaySDK.h>
#import <UIKit/UIKit.h>
//微信
#import "WXApi.h"
#import "WXApiRequestHandler.h"
///**y银联支付*/
//#import "UPPaymentControl.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^paySuccessBlock)(void);
typedef void(^payFailedBlock)(void);

@interface YKAlipayTool : NSObject

+ (instancetype)shareInstance;

/**
 支付宝支付参数
 */
@property (nonatomic, copy) NSString *aliPayJson;

/**
 微信预支付订单号
 */
@property (nonatomic, copy) NSString *orderNum;

/**
 微信wxAppId
 */
@property (nonatomic, copy) NSString *wxAppId;

/**
 微信wxPartnerId 商户号
 */
@property (nonatomic, copy) NSString *wxPartnerId;

/**
 微信wxAppSecret
 */
@property (nonatomic, copy) NSString *wxAppSecret;

/**
 微信wxPartnerKey
 */
@property (nonatomic, copy) NSString *wxPartnerKey;

/**
 包名
 */
@property (nonatomic, copy) NSString *bundleIdentifer;

/**
 银联支付需要的
 */
@property (nonatomic,strong) UIViewController *currentVC;

/**
 调起支付的综合方法

 @param payType 支付方式
 @param orderMsg  订单信息
 @param bundleIdentifer 项目的包名
 @param currentViewController  当前的控制器
 */
- (void)gopayByPayType:(NSString *)payType
              orderMsg:(NSDictionary *)orderMsg
       bundleIdentifer:(NSString *)bundleIdentifer
 currentViewController:(UIViewController *)currentViewController;

@property (nonatomic,copy) paySuccessBlock paySuccess;
@property (nonatomic,copy) payFailedBlock payFailed;

NS_ASSUME_NONNULL_END
@end

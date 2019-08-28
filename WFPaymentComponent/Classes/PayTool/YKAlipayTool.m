//
//  YKAlipayTool.m
//  YukiFramework
//
//  Created by 王宇 on 2018/5/31.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YKAlipayTool.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "WFPaymentHelp.h"

@implementation YKAlipayTool

+ (instancetype)shareInstance {
    static YKAlipayTool *pay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pay = [[YKAlipayTool alloc] init];
    });
    return pay;
}

#pragma mark  支付宝支付
- (void)gopayForAlipay{
    // NOTE: 如果加签成功，则继续执行支付
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
    NSString *appScheme = self.bundleIdentifer;
    
    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
    //        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
    //                                 orderInfoEncoded, signedString];
    NSString *orderString = self.aliPayJson;
    
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}

#pragma mark 微信支付
- (void)gopayForWeChat{
    NSString *prePayOrderNum = self.orderNum;//
    if (prePayOrderNum.length !=0  && [WXApi isWXAppInstalled]) {

        //创建支付签名对象
        WXApiRequestHandler *req = [[WXApiRequestHandler alloc]init];
        //初始化支付签名对象
        [req init:self.wxAppId mch_id:self.wxPartnerId];

        //设置密钥
        [req setKey:self.wxPartnerKey];

        NSString *phoneIP = [self getPhoneIP];//手机IP
        NSString *TradeName = @"商品名";//商品名
//        NSString *PayMoney = [NSString stringWithFormat:@"%.2f",[self.totalPrice doubleValue]];//价格
        NSString *PayMoney = @"0.2";
        NSString *prepayId = prePayOrderNum;//获取prepayId（预支付交易会话标识）

        //获取到实际调起微信支付的参数后，在app端调起支付
        NSMutableDictionary *dict = [req sendPay:TradeName price:PayMoney PhoneIP:phoneIP WeixinprepayId:prepayId];

        if(dict == nil){
            //错误提示
            NSString *debug = [req getDebugifo];

            NSLog(@"%@\n\n",debug);
        }else{
            NSLog(@"%@\n\n",[req getDebugifo]);
            //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];

            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];

            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
        }

    }
}

#pragma mark 银联支付
- (void)gopayUnionpay{
    
//    NSString *tradeNo = @"897646586994730884016";
//    if (tradeNo.length > 0)
//    {
//        [[UPPaymentControl defaultControl] startPay:tradeNo fromScheme:@"com.wangyu.cn.YukiFramework" mode:YinLianZhengShi viewController:self.currentVC];   // mode  支付环境
//    }
}

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
 currentViewController:(UIViewController *)currentViewController {
    self.bundleIdentifer = bundleIdentifer;
    if([payType containsString:@"支付宝"]){
        self.aliPayJson = [NSString stringWithFormat:@"%@",[orderMsg objectForKey:@"aliPayJson"]];
        if (self.aliPayJson.length == 0) {
            NSLog(@"支付字符串错误");
            return;
        }
        [self gopayForAlipay];
    }else if ([payType containsString:@"微信"]){
        //appid
        self.wxAppId = [NSString stringWithFormat:@"%@",[orderMsg objectForKey:@"wxAppId"]];
        //wxPartnerId
        self.wxPartnerId = [NSString stringWithFormat:@"%@",[orderMsg objectForKey:@"wxPartnerId"]];
        //wxPartnerKey
        self.wxPartnerKey = [NSString stringWithFormat:@"%@",[orderMsg objectForKey:@"wxPartnerKey"]];
        if (self.wxAppId.length == 0 || self.wxPartnerId.length == 0 || self.wxPartnerKey.length == 0) {
            NSLog(@"支付字符串错误");
            return;
        }
        [self gopayForWeChat];
    }else if ([payType containsString:@"银联"]){
        self.currentVC = currentViewController;
        [self gopayUnionpay];
    }
}

#pragma mark   ==============产生随机订单号==============

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

//获取手机IP
- (NSString *)getPhoneIP {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    if ([address isEqualToString:@"error"])
    {
        address = @"192.168.1.1";
    }
    return address;
    
}

@end

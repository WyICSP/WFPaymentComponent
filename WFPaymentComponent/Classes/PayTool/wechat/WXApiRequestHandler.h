//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"

#define APP_ID          @"wxa1561d1224f9f2bd"               //APPID
#define APP_SECRET      @"d6333fdb4602c5714bfa3471df515c1e" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1266312401"
//商户API密钥，填写相应参数
#define PARTNER_ID      @""  //从网络获取
//支付结果回调页面
#define NOTIFY_URL @"http://61.165.138.145:10004/pay/wxpayNotice"
//http://121.199.27.75:255/WeiXinPayNotify.aspx
//http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"


@interface WXApiRequestHandler : NSObject{
    //预支付网关url地址
    NSString *payUrl;
    
    //lash_errcode;
    long     last_errcode;
    //debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
}

+ (NSString *)jumpToBizPay;



//初始化函数
-(BOOL) init:(NSString *)app_id mch_id:(NSString *)mch_id;
//设置商户密钥
-(void) setKey:(NSString *)key;

//获取debug信息
-(NSString*) getDebugifo;

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict;

//商品的名称＋价格参数
- ( NSMutableDictionary *)sendPay:(NSString *)TradeName price:(NSString *)price PhoneIP:(NSString *)Ip WeixinprepayId:(NSString *)WEprepayId;

@end

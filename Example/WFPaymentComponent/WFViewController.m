//
//  WFViewController.m
//  WFPaymentComponent
//
//  Created by wyxlh on 07/18/2019.
//  Copyright (c) 2019 wyxlh. All rights reserved.
//

#import "WFViewController.h"
#import "YKAlipayTool.h"
#import "WXApi.h"

@interface WFViewController ()

@end

@implementation WFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"-------%d",[WXApi isWXAppInstalled]);
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]])
    {
        NSLog(@"OK wechat://");
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"wechat://"]];
    }
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)clickAlipay:(id)sender {
//    NSString *json = @"alipay_sdk=alipay-sdk-java-3.3.87.ALL&app_id=2019042564306566&biz_content=%7B%22body%22%3A%22%E4%BA%91%E6%99%BA%E5%85%85-%E5%85%85%E5%80%BC%22%2C%22out_trade_no%22%3A%2220190718143419070%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22subject%22%3A%22%E4%BA%91%E6%99%BA%E5%85%85-%E5%85%85%E5%80%BC%22%2C%22timeout_express%22%3A%2230m%22%2C%22total_amount%22%3A%220.01%22%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fdev.jx9n.cn%3A10004%2Fpay%2FaliPayNotice&sign=dNR8Qnh2mpr94YjmzMuD54pkVjhYZrvtc7mVImknhW5U%2BJy4Xna9x8RXdlyo7ZXIi%2BjR0RwE%2Fv8%2FaZVj8PTg4nQjv06geg7D%2B56ltcb2huc6RT9YBo6sYiW33tX5ns3p3jnbepzMmyOcCF6zEuxloOz5gso%2Fgjzfxo72i3ZouQBzb7zE4mugsmcBj5mxWxT77FDKRD5Ss0vGw6%2B3o8Q6FNGSofL4tUQJ%2Bdhn38mgNhT19MrX7RP87IyKiEPEwFDtO3SDwRYA7DvnYRrPwluQHbVa5X2%2FOeDWOSmSRC1crmzb5uSZpdFyfrpq5duWOkoCMMYtkZYWeH2HOFjczhXhBw%3D%3D&sign_type=RSA2&timestamp=2019-07-18+14%3A34%3A19&version=1.0";
    [[YKAlipayTool shareInstance] gopayByPayType:@"支付宝"
                                        orderMsg:@{}
                                 bundleIdentifer:@"com.dream.zncd.intelligentchargeText"
                           currentViewController:self];
}
- (IBAction)clickWechat:(id)sender {
//    NSString *orderNum = @"wx18143501608326d5bd6110981803096200";
    [[YKAlipayTool shareInstance] gopayByPayType:@"支付宝"
                                        orderMsg:@{}
                                 bundleIdentifer:@"com.dream.zncd.intelligentchargeText"
                           currentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

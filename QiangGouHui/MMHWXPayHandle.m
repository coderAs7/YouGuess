//
//  MMHWXPayHandle.m
//  MamHao
//
//  Created by fishycx on 15/8/9.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHWXPayHandle.h"
#import "MMHNetworkEngine.h"
#import "MMHNetworkAdapter+Order.h"
#import "QGHWeChatPrePayModel.h"


@implementation MMHWXPayHandle


+ (MMHWXPayHandle *)wxPayHandle {
    static MMHWXPayHandle *wxPayHandle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wxPayHandle = [[self alloc] init];
    });
    return wxPayHandle;
}


//- (NSString *)getCallBackURLWithType:(MMHPayType)payType {
//    
//    //    payOrder.notifyURL = mmhCallbackURL;
//    NSString *url = @"";
//    if ([[MMHNetworkEngine sharedEngine].baseURL.host isEqualToString:@"api.mamhao.cn"]) {
//        
//        if (payType != MMHPayTypeForVIP) {
//            url = @"http://api.mamhao.cn/wxpay/build.do";
//        } else {
//            url = @"http://api.mamhao.cn/vip/wxpay/build.do";
//            
//        }
//    } else {
//        NSString *apiPath = [MMHNetworkEngine sharedEngine].baseURL.absoluteString;
//        if (![apiPath hasSuffix:@"/"]) {
//            apiPath = [apiPath stringByAppendingString:@"/"];
//        }
//        if (payType != MMHPayTypeForVIP) {
//            url = [NSString stringWithFormat:@"%@wxpay/build.do", apiPath];
//            
//        } else {
//            url = [NSString stringWithFormat:@"%@vip/wxpay/build.do", apiPath];
//            
//        }
//        
//    }
//    return url;
//    
//}

- (void)callWeChatPay:(QGHWeChatPrePayModel *)prePayModel {
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = prePayModel.partnerid;
    request.prepayId = prePayModel.prepay_id;
    request.package = @"Sign=WXPay";
    request.nonceStr = prePayModel.nonceStr;
    request.timeStamp = prePayModel.timeStamp;
    request.sign = prePayModel.paySign;
    [WXApi sendReq: request];
}


- (void)sendPayWithOrder:(NSString *)payOrder
{
    
    [[MMHNetworkAdapter sharedAdapter] sendRequestWechatPayDataFrom:self orderNo:payOrder succeededHandler:^(QGHWeChatPrePayModel *prePayModel) {
        [self callWeChatPay:prePayModel];
    } failedHandler:^(NSError *error) {
        //Nothing to do
    }];
    //从服务器获取支付参数，服务端自定义处理逻辑和格式
    //订单标题
//    NSString *ORDER_NAME =payOrder.productName;
//    //订单金额，单位（元）
//    NSString *ORDER_PRICE   = payOrder.amount;
//    NSString *ORDER_TRADENO = payOrder.tradeNO;
//    NSString *ORDER_PRODUCTDESCRIPTION=payOrder.productDescription;
    //根据服务器端编码确定是否转码
//    NSStringEncoding enc;
//    //if UTF8编码
//    //enc = NSUTF8StringEncoding;
//    //if GBK编码
//    enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSString *urlString = [NSString stringWithFormat:@"%@?orderNo=%@",
//                           [self getCallBackURLWithType:payType],payOrder];
//    
//    //解析服务端返回json数据
//    NSError *error;
//    //加载一个NSURL对象
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    //将请求的url数据放到NSData对象中
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if ( response != nil) {
//        NSMutableDictionary *dict = NULL;
//        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//        
//        NSLog(@"url:%@",urlString);
//        if(dict != nil){
//            NSMutableString *retcode = [dict objectForKey:@"retcode"];
//            if (retcode.intValue == 0){
//#if !TARGET_IPHONE_SIMULATOR
//                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//                
//                //调起微信支付
//                PayReq* req             = [[PayReq alloc] init];
//                req.openID              = [dict objectForKey:@"appid"];
//                req.partnerId           = [dict objectForKey:@"partnerid"];
//                req.prepayId
//                = [dict objectForKey:@"prepayid"];
//                req.nonceStr            = [dict objectForKey:@"noncestr"];
//                req.timeStamp           = stamp.intValue;
//                req.package             = [dict objectForKey:@"package"];
//                req.sign                = [dict objectForKey:@"sign"];
//                
//              BOOL xxx =[WXApi sendReq:req];
//                NSLog(@"the xxx is: %d", xxx);
//#endif
//            }else{
//                [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
//            }
//        }else{
//            [self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
//        }
//    }else{
//        [self alert:@"提示信息" msg:@"服务器返回错误"];
//    }
}
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}


@end

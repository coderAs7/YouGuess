//
//  MMHAliPayHandle.m
//  MamHao
//
//  Created by SmartMin on 15/5/26.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHAliPayHandle.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "MMHNetworkEngine.h"


@implementation MMHAliPayHandle


+(MMHAliPayHandle *)alipayOrderNoShared{
    static MMHAliPayHandle *alipayHandle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        alipayHandle = [[self alloc] init];
    });
    return alipayHandle;
}


#pragma mark - go pay


+ (void)goPayWithOrder:(MMHPayOrderModel *)payOrder {
    NSString *fileMessage = @"";
    static NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMu6BBDqESmWeugDnxBXVzaR5XSOXd33d9qiUIFgPKJnYlf1QeYqwbvqYmBQinKd7FLvf+3A8+Lq0jCIMpuYqxdJGQqvGCuqizb8SJo3+nX2SMAGA2+6qKRo25gxrJQiL1U/GOKKzm7LkgD65GL7k5GX5pIWwr69oaLkICMg7JGLAgMBAAECgYAbNZfvbmOma0u1Cy7GbvPd/PRpcc5FpBSk5cLc1K6kfixbVQ1dIV7Iq1BCTt9+2WrD1OsAJSItr3EtPDOOJoDLGSqaRP3HQrEtZ8nzDE/ET9B7TFViQCowlGkTcZT6b5acQ2066kRuvZxM011+Wy8t1lN+h4nava2qW5A3HQBggQJBAPfB/S6lSFbjBUxur3DLmnRMcJ7no9hEzuqTQ/ThdtuAd5iRqVWfMji/7O/hMOL0ikGmQCe/FSH2LpOeYicdz0ECQQDSgQnyCw2psHBdTjVZvukXNd19m+G3RFAjXQLS0ZtQibnwTeOdu5fhumeVIyRFjvEunJlTLKioFn9r9ACj8/nLAkEA8W7gwiveqozgBPN3k3tVMC+tL6ybRY0H9h88Ac4UfSJbaRnI4d8YmaStx7SyZvfWItNXgWP7u/SivseA7o1mAQJAf5pHHBkFNDrHMlhJUNjAVRiK5iyLG9vmNDmaj48N9jk2pGuisafYvrWPOsFtqFio7Ndyvg+RQSs6HIdxp/EqFwJBAMAjqhPAt7fi/O9mnHcT0NKUQKNVzb+DTK+Gd//C1xy0x5uStc6LPsUdxHB+9vlrdjCPf1mtFDQOzuahvrMRxkU=";
    static NSString *partner = @"2088221830605320";
    static NSString *seller = @"gz_ruanyin@126.com";
    
    payOrder.notifyURL = @"http://121.14.38.35/callback.php";
    payOrder.partner = partner;
    payOrder.seller = seller;
    payOrder.service = @"mobile.securitypay.pay";
    payOrder.paymentType = @"1"; 
    payOrder.inputCharset = @"utf-8";
    payOrder.itBPay = @"30m";
    payOrder.showUrl = @"m.alipay.com";
    
    NSLog(@"alipayHandle:notifyURL->%@ privateKey->%@ partner->%@ seller->%@", payOrder.notifyURL, privateKey, partner, seller);
    
    if ((!partner.length) || (!seller.length) || (!privateKey.length)){
        fileMessage = @"主要参数缺省";
    }
    
    if (!payOrder.tradeNO){
        fileMessage = @"没有单号";
    } else if (!payOrder.productName){
        fileMessage = @"没有商品名称";
    } else if (!payOrder.amount){
        fileMessage = @"没有商品价格";
    }
    
    if (fileMessage.length){
        return;
    }
    
    NSString *appScheme = @"QiangGouHui-alipay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [payOrder description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        /*
         9000 订单支付成功
         8000 正在处理中
         4000 订单支付失败
         6001 用户中途取消
         6002 网络连接出错
         */
        
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSMutableDictionary *resultTempDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
            NSString *tempTargetString = @"";
            NSString *payResult = [resultDic objectForKey:@"result"];
            NSArray *tempArr = [payResult componentsSeparatedByString:@"&"];
            for (int i = 0 ; i < tempArr.count;i++){
                NSString *tempString = [tempArr objectAtIndex:i];
                if ([MMHAliPayHandle searchTargetWithString:tempString].length){
                    tempTargetString = [MMHAliPayHandle searchTargetWithString:tempString];
                    break;
                }
            }
            
            if (![tempTargetString isEqualToString:[MMHAliPayHandle alipayOrderNoShared].alipayOutTradeNo]){
                [resultTempDic setObject:tempTargetString forKey:@"resultOrderNo"];
                [[NSNotificationCenter defaultCenter] postNotificationName:MMHAlipayNotification object:nil userInfo:resultTempDic];
            }else{
            
            }
        }];
    }
}


+ (NSString *)searchTargetWithString:(NSString *)string{
    NSString *targetOrderNo = @"";
    NSRange range=[string rangeOfString:@"out_trade_no"];
    if(range.location != NSNotFound){
        NSArray *array=[string componentsSeparatedByString:@"\""];
        targetOrderNo = [array objectAtIndex:1];
    }
    return targetOrderNo;
}

@end

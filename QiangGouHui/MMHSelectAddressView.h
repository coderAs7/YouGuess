//
//  MMHSelectAddressView.h
//  MamHao
//
//  Created by fishycx on 16/1/16.
//  Copyright © 2016年 Mamahao. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class MMHAddressSingleModel;


typedef void(^MMHSelectAddressViewCallBack)(NSString *province, NSString *city, NSString *area);

@interface MMHSelectAddressView : UIView


@property (nonatomic, copy) MMHSelectAddressViewCallBack callback;
- (void)show;
@end

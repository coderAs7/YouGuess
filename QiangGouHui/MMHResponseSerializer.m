//
//  MMHResponseSerializer.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/1.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHResponseSerializer.h"


@implementation MMHResponseSerializer


- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (string && [response.MIMEType isEqualToString:@"application/json"]) {
//        LZLog(@"the response is: %@", response);
//        LZLog(@"got response string: %@", string);
//        NSLog(@"the response is: %@", response);
//        NSLog(@"got response string: %@", string);
    }
    else {
        NSLog(@"ERROR: can not parse response string");
    }
    
    return [super responseObjectForResponse:response
                                       data:data
                                      error:error];
}


@end

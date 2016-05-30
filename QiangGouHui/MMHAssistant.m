//
//  MMHAssistant.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/1.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHAssistant.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/xattr.h>
#import "MBProgressHUD.h"
//#import "LESAlertView.h"
#import <objc/runtime.h>
//#import "MMHPersonalInfoModelManager.h"
//#import "MMHPersonalInfoModel.h"


NSString *const MMHUserDidLoginNotification = @"MMHUserDidLoginNotification";
NSString *const MMHUserDidLogoutNotification = @"MMHUserDidLogoutNotification";
NSString *const MMHUserPersonalInformationFetchedNotification = @"MMHUserPersonalInformationFetchedNotification";
NSString *const MMHUserPersonalInformationDidCompleteNotification = @"MMHUserPersonalInformationDidCompleteNotification";
NSString *const MMHUserPersonalInformationChangedNotification = @"MMHUserPersonalInformationChangedNotification";

NSString *const MMHUnreadMessageCountDidChangeNotification = @"MMHUnreadMessageCountDidChangeNotification";


BOOL MMHUsingAPIMamahaoCom() {
#if defined (API_MAMAHAO_COM)
    return YES;
#else
    return NO;
#endif
}


BOOL CHTIsUserIDAvailableForUserDetail(NSString *userID) {
    return [userID rangeOfCharacterFromSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]].location == NSNotFound;
}


BOOL mmh_option_contains_bit(NSUInteger option, NSUInteger bit)
{
    if (option & bit) {
        return YES;
    }
    return NO;
}


CGFloat mmh_screen_scale()
{
    return ([UIScreen instancesRespondToSelector:@selector(scale)]?[[UIScreen mainScreen] scale]:(1.0f));
}


CGFloat mmh_screen_width()
{
    return ([[UIScreen mainScreen] applicationFrame].size.width);
}

CGFloat mmh_screen_height()
{
    return ([[UIScreen mainScreen] applicationFrame].size.height);
}

CGFloat mmh_pixel()
{
    static CGFloat pixel = 1.0f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pixel = 1.0f / mmh_screen_scale();
    });
    return pixel;
}


CGFloat MMHFloat(CGFloat floatValue)
{
    return MMHFloatWithPadding(floatValue, 0.0f);
}


CGFloat MMHFloatWithPadding(CGFloat floatValue, CGFloat padding)
{
    CGFloat currentScreenWidth = mmh_screen_width() - padding;
    CGFloat standardScreenWidth = 375.0f - padding;
    return floorf(floatValue / standardScreenWidth * currentScreenWidth);
}


CGPoint MMHPoint(CGPoint pointValue)
{
    return CGPointMake(MMHFloat(pointValue.x), MMHFloat(pointValue.y));
}


CGSize MMHSize(CGSize sizeValue)
{
    return CGSizeMake(MMHFloat(sizeValue.width), MMHFloat(sizeValue.height));
}


CGRect MMHRect(CGRect rectValue)
{
    return CGRectMake(MMHFloat(rectValue.origin.x), MMHFloat(rectValue.origin.y), MMHFloat(rectValue.size.width), MMHFloat(rectValue.size.height));
}


CGPoint MMHPointMake(CGFloat x, CGFloat y)
{
    return CGPointMake(MMHFloat(x), MMHFloat(y));
}


CGSize MMHSizeMake(CGFloat width, CGFloat height)
{
    return CGSizeMake(MMHFloat(width), MMHFloat(height));
}


CGRect MMHRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    return CGRectMake(MMHFloat(x), MMHFloat(y), MMHFloat(width), MMHFloat(height));
}


UIEdgeInsets UIEdgeInsetsWithTop(CGFloat top)
{
    return UIEdgeInsetsMake(top, 0.0f, 0.0f, 0.0f);
}


UIEdgeInsets UIEdgeInsetsWithLeft(CGFloat left)
{
    return UIEdgeInsetsMake(0.0f, left, 0.0f, 0.0f);
}


UIEdgeInsets UIEdgeInsetsWithBottom(CGFloat bottom)
{
    return UIEdgeInsetsMake(0.0f, 0.0f, bottom, 0.0f);
}


UIEdgeInsets UIEdgeInsetsWithRight(CGFloat right)
{
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, right);
}


UIEdgeInsets MMHEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
{
    return UIEdgeInsetsMake(MMHFloat(top), MMHFloat(left), MMHFloat(bottom), MMHFloat(right));
}


extern CGFloat MMHFontSize(CGFloat pointSize)
{
    if (mmh_screen_width() == 320) {
        return MMHFloat(pointSize + 2.0f);
    }
    return MMHFloat(pointSize);
}


UIFont *MMHFontOfSize(CGFloat pointSize)
{
    return [UIFont systemFontOfSize:MMHFontSize(pointSize)];
}


CGSize CGSizePixelToPoint(CGSize sizeOfPixel)
{
    CGSize sizeOfPoint = sizeOfPixel;
    sizeOfPoint.width /= mmh_screen_scale();
    sizeOfPoint.height /= mmh_screen_scale();
    return sizeOfPoint;
}


CGSize CGSizePointToPixel(CGSize sizeOfPoint)
{
    CGSize sizeOfPixel = sizeOfPoint;
    sizeOfPixel.width *= mmh_screen_scale();
    sizeOfPixel.height *= mmh_screen_scale();
    return sizeOfPixel;
}


NSString *MMHPathTemp() {
    return NSTemporaryDirectory();
}


NSString *MMHPathDocuments() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}


NSString *MMHPathDocumentsAppendingPathComponent(NSString *pathComponent) {
    return [MMHPathDocuments() stringByAppendingPathComponent:pathComponent];
}


@implementation NSObject (MamHao)


- (BOOL)notNilOrEmpty
{
    if ((NSNull *)self == [NSNull null]) {
        return NO;
    }
    
    if ([self respondsToSelector:@selector(count)]) {
        if ([(id)self count] == 0) {
            return NO;
        }
    }
    
    if ([self respondsToSelector:@selector(length)]) {
        if ([(id)self length] == 0) {
            return NO;
        }
    }
    
    return YES;
}


@end


@implementation NSString (MamHao)
/**
 是不是含有表情
 */
-(BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}

- (BOOL)isPureIntNumber {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (NSString *)md5String
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)(strlen(cStr)), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


- (NSString *)sha1String
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}


- (NSString *)encryptString
{
    char const *cString = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned long size = strlen(cString);
//    NSLog(@"size: %ld", (long)size);
    char *p = (char *)cString;
    char *dString = (char *)malloc(sizeof(char) * (size + 1));
    char *q = dString;
    while (*p != '\0') {
        char c = *p;
//        NSLog(@"the c: %c", c);
        *q = (char)(c ^ 't');
        p++;
        q++;
    }
    *q = '\0';
    NSString *string = [NSString stringWithCString:dString encoding:NSUTF8StringEncoding];
    free(dString);
    return string;
#if 0
    char[] a = inStr.toCharArray();  
        for (int i = 0; i < a.length; i++){  
            a[i] = (char) (a[i] ^ 't');  
        }  
        String s = new String(a); 
        #endif
}


- (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacters
{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}


- (NSString *)stringByTrimmingWhitespaceAndNewlineCharacters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding));
}


- (NSString *)URLEncodedString
{
    return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}


- (NSString *)URLDecodedString
{
    return CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(NULL, (__bridge CFStringRef)self, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/")));
}


+ (NSString *)stringWithDate:(NSDate *)date dateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = nil;
    if (format == nil) {
        dateFormat = @"y.MM.dd HH: mm: ss";
    } else {
        dateFormat = format;
    }
    formatter.dateFormat = dateFormat;
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}


- (NSComparisonResult)versionNumberCompare:(NSString *)string
{
    NSCharacterSet *numberAndDotCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *trimmedSelf = [self stringByTrimmingCharactersInSet:numberAndDotCharacterSet];
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:numberAndDotCharacterSet];
    NSArray *selfComponents = [trimmedSelf componentsSeparatedByString:@"."];
    NSArray *stringComponents = [trimmedString componentsSeparatedByString:@"."];
    NSUInteger selfComponentsCount = [selfComponents count];
    NSUInteger stringComponentsCount = [stringComponents count];
    NSUInteger comparableComponentsCount = MIN(selfComponentsCount, stringComponentsCount);
    
    for (NSUInteger i = 0; i < comparableComponentsCount; i++) {
        NSString *aSelfComponent = selfComponents[i];
        NSString *aStringComponent = stringComponents[i];
        NSComparisonResult result = [aSelfComponent compare:aStringComponent options:NSNumericSearch];
        if (result != NSOrderedSame) {
            return result;
        }
    }
    
    NSComparisonResult result = [@(selfComponentsCount) compare:@(stringComponentsCount)];
    return result;
}


// 是否是邮箱
- (BOOL)conformsToEMailFormat
{
    return [self matchesRegularExpressionPattern:@".+@.+\\..+"];
}


// 长度是否在一个范围之内
- (BOOL)isLengthGreaterThanOrEqual:(NSInteger)minimum lessThanOrEqual:(NSInteger)maximum
{
    return ([self length] >= minimum) && ([self length] <= maximum);
}


- (NSRange)firstRangeOfURLSubstring
{
    static NSDataDetector *dataDetector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataDetector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypeLink | NSTextCheckingTypeLink)
                                                       error:nil];
    });
    
    NSRange range = [dataDetector rangeOfFirstMatchInString:self
                                                    options:0
                                                      range:NSMakeRange(0, [self length])];
    return range;
}


- (NSString *)firstURLSubstring
{
    NSRange range = [self firstRangeOfURLSubstring];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    return [self substringWithRange:range];
}


- (NSString *)firstMatchUsingRegularExpression:(NSRegularExpression *)regularExpression
{
    NSRange range = [regularExpression rangeOfFirstMatchInString:self
                                                         options:0
                                                           range:NSMakeRange(0, [self length])];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    return [self substringWithRange:range];
}


- (NSString *)firstMatchUsingRegularExpressionPattern:(NSString *)regularExpressionPattern
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    return [self firstMatchUsingRegularExpression:regularExpression];
}


- (BOOL)matchesRegularExpressionPattern:(NSString *)regularExpressionPattern
{
    NSRange fullRange = NSMakeRange(0, [self length]);
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    NSRange range = [regularExpression rangeOfFirstMatchInString:self
                                                         options:0
                                                           range:fullRange];
    if (NSEqualRanges(fullRange, range)) {
        return YES;
    }
    return NO;
}


- (BOOL)containInvalidString {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:set];
    if ([self matchesRegularExpressionPattern:trimmedString]) {
        return NO;
    }
    return YES;
}


- (NSRange)rangeOfFirstMatchUsingRegularExpressionPattern:(NSString *)regularExpressionPattern
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    NSRange range = [regularExpression rangeOfFirstMatchInString:self
                                                         options:0
                                                           range:NSMakeRange(0, [self length])];
    return range;
}


- (NSString *)stringByReplacingMatchesUsingRegularExpressionPattern:(NSString *)regularExpressionPattern withTemplate:(NSString *)templ
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    NSString *string = [regularExpression stringByReplacingMatchesInString:self
                                                                   options:0
                                                                     range:NSMakeRange(0, [self length])
                                                              withTemplate:templ];
    return string;
}


- (CGSize)sizeWithSingleLineFont:(UIFont *)font
{
    NSStringDrawingOptions options = 0;
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGSize size = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:options
                                  attributes:attributes
                                     context:nil].size;
    return size;
    //    CGSize size = [text sizeWithFont:self.font
    //                            forWidth:maxWidth
    //                       lineBreakMode:NSLineBreakByWordWrapping];
}


- (id)jsonObject
{
    NSError *error = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"ERROR: cannot convert string to JSON object: %@", self);
        return nil;
    }

    return object;

}



- (BOOL)isChineseCharacter {
    NSString *regex = @"^[\u4E00-\u9FA5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];

}


- (BOOL)isNumberOrEnglishOrChineseCharacter {
    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}


- (BOOL)isPureNumandCharacters
{
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}


+ (NSString *)filePathWithName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectory = paths.lastObject;
    NSString *filePath = [doucumentsDirectory stringByAppendingPathComponent:name];
    return filePath;
}



//+ (NSString *)defautPortraitNameWithUserIdentity:(MMHUserIdentity)userIdentity {
//        switch (userIdentity) {
//            case MMHUserIdentityMom:
//            {
//                return @"yichusheng";
//            }
//                break;
//            case MMHUserIdentityPregnant:
//            {
//                return @"animation_Icon_ gravida";
//            }
//                break;
//            case MMHUserIdentityPreparingToPregant:
//            {
//                return @"animation_Icon_ ungravida";
//            }
//                break;
//            case MMHUserIdentityUnspecified:
//            {
//                return @"mmh_img_morentouxiang";
//            }
//                break;
//            default:
//                break;
//        }
//    return @"";
//}


//+ (NSString *)pureStringWithPrice:(MMHPrice)price {
//    NSString *string = [self stringWithFormat:@"%.2f", price];
//    if ([string hasSuffix:@".00"]) {
//        return [string substringToIndex:string.length - 3];
//    }
//    
//    if ([string hasSuffix:@"0"]) {
//        return [string substringToIndex:string.length - 1];
//    }
//    
//    return string;
//}
//
//
//+ (NSString *)stringWithPrice:(MMHPrice)price {
//    return [NSString stringWithFormat:@"￥%@", [self pureStringWithPrice:price]];
//}
//
//
//+ (NSString *)beanPriceStringWithPrice:(MMHPrice)price beanPrice:(long)beanPrice
//{
//    if (beanPrice && (price != 0.0f)) {
//        return [NSString stringWithFormat:@"%li妈豆 + %@", beanPrice, [NSString stringWithPrice:price]];
//    }
//    return [NSString stringWithFormat:@"%li妈豆", beanPrice];
//}
//
//
//- (MMHPrice)priceValue
//{
//    return (MMHPrice)[self floatValue];
//}
//
//
//+ (NSString *)stringWithMMHID:(MMHID)mmhid
//{
//    return [self stringWithFormat:@"%ld", mmhid];
//}
//
//
//- (MMHID)MMHIDValue
//{
//    return (MMHID)[self integerValue];
//}


+ (NSString *)stringWithMonthAge:(long)monthAge
{
    if (monthAge < 0) {
        return @"未出生";
    }

    if (monthAge == 0) {
        return @"新生儿";
    }

    if (monthAge < 12) {
        return [self stringWithFormat:@"%ld个月", monthAge];
    }

    long year = monthAge / 12;
    long month = monthAge % 12;
    return [self stringWithFormat:@"%ld岁%ld个月", year, month];
}


+ (NSString *)stringWithSoldCount:(long)soldCount {
    if (soldCount <= 0) {
        return @"";
    }
    
    if (soldCount < 10000) {
        return [NSString stringWithFormat:@"已售%ld件", soldCount];
    }
    
    if (soldCount < 10000000) {
        NSMutableString *countString = [NSMutableString stringWithFormat:@"%ld", soldCount];
        [countString deleteCharactersInRange:NSMakeRange(countString.length - 3, 3)];
        if ([countString hasSuffix:@"0"]) {
            [countString deleteCharactersInRange:NSMakeRange(countString.length - 1, 1)];
        }
        else {
            [countString insertString:@"." atIndex:countString.length - 1];
        }
        return [NSString stringWithFormat:@"已售%@万件", countString];
    }
    
    return @"已售1000万+件";
}


+ (NSString *)stringWithCrowdfundingAmount:(long)crowdfundingAmount {
    if (crowdfundingAmount <= 0) {
        return @"0元";
    }
    if (crowdfundingAmount < 10000) {
        return [NSString stringWithFormat:@"%ld元", crowdfundingAmount];
    } else {
        double price = crowdfundingAmount * 1.0 / 10000;
        NSString *string = [self stringWithFormat:@"%.2lf", price];
        if ([string hasSuffix:@".00"]) {
            
            return [NSString stringWithFormat:@"%@万",[string substringToIndex:string.length - 3]];
        }
        
        if ([string hasSuffix:@"0"]) {
            return [NSString stringWithFormat:@"%@万",[string substringToIndex:string.length - 1]];
        }

        return [NSString stringWithFormat:@"%@万",string];
    }
}


+ (NSString *)stringWithPureSoldCountString:(NSString *)pureSoldCountString {
    if (pureSoldCountString.length == 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"已售%@件", pureSoldCountString];
}


+ (NSString *)stringSeparateByCommaFromArray:(NSArray<NSString *> *)array {
   NSString *fileImageString = @"";
    for (int i = 0; i < array.count; i++) {
        NSString *string = array[i];
        if (i == array.count - 1) {
           fileImageString = [fileImageString stringByAppendingString:string];
        } else {
           fileImageString = [fileImageString stringByAppendingString:[NSString stringWithFormat:@"%@,", string]];
            
        }
    }
    return fileImageString;
}


- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)maxWidth lineCount:(NSUInteger)maxLineCount {
    BOOL anyBoolFalue;
    return [self sizeWithFont:font constrainedToWidth:maxWidth lineCount:maxLineCount constrained:&anyBoolFalue];
}


- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)maxWidth lineCount:(NSUInteger)maxLineCount constrained:(BOOL *)constrained {
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    NSDictionary *attributes = @{NSFontAttributeName: font};
    if (maxLineCount == 0) {
        CGSize size = [self boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                         options:options
                                      attributes:attributes
                                         context:nil].size;
        width = size.width;
        height = size.height;
        if (constrained != nil) {
            *constrained = NO;
        }
    }
    else {
        NSMutableString *testString = [NSMutableString stringWithString:@"X"];
        for (NSInteger i = 0; i < maxLineCount - 1; i++) {
            [testString appendString:@"\nX"];
        }
        
        CGSize maxSize = [testString boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                     options:options
                                                  attributes:attributes
                                                     context:nil].size;
        CGSize textSize = [self boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                options:options
                                             attributes:attributes
                                                context:nil].size;
        width = textSize.width;
        if (maxSize.height < textSize.height) {
            if (constrained != nil) {
                *constrained = YES;
            }
            height = maxSize.height;
        }
        else {
            if (constrained != nil) {
                *constrained = NO;
            }
            height = textSize.height;
        }
    }
    width = ceilf(width);
    height = ceilf(height);
    return CGSizeMake(width, height);
}


- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)maxWidth lineCount:(NSUInteger)maxLineCount
{
    return [self sizeWithFont:font constrainedToWidth:maxWidth lineCount:maxLineCount].height;
}


- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)maxWidth lineCount:(NSUInteger)maxLineCount constrained:(BOOL *)constrained
{
    return [self sizeWithFont:font constrainedToWidth:maxWidth lineCount:maxLineCount constrained:constrained].height;
}


@end


@implementation NSAttributedString (MamHao)


- (CGFloat)heightConstrainedToWidth:(CGFloat)maxWidth
{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, maxWidth, 0.0f)];
//    label.attributedText = self;
//    label.numberOfLines = 0;
//    
    
    CGFloat height = 0.0f;
    
    NSStringDrawingOptions options = (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [self boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                     options:options
                                     context:nil].size;
    
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, maxWidth, 0.0f)];
//    label.numberOfLines = 0;
    label.contentInset = UIEdgeInsetsMake(-8.0f, -3.0f, -8.0f, -3.0f);
    label.attributedText = self;
    [label sizeToFit];
    label.contentInset = UIEdgeInsetsMake(-8.0f, -3.0f, -8.0f, -3.0f);

    size = label.frame.size;
    
    height = ceilf(size.height);
    return height - 15.0f;
}


@end


@implementation NSNumber (MamHao)


//- (MMHPrice)priceValue
//{
//    return (MMHPrice)[self floatValue];
//}
//
//
//- (MMHID)MMHIDValue
//{
//    return (MMHID)[self longValue];
//}


@end


@implementation NSArray (MamHao)


- (id)firstObject
{
    if ([self count] == 0) {
        return nil;
    }
    return [self objectAtIndex:0];
}


- (NSArray *)arrayWithObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:predicate];
    return [self objectsAtIndexes:indexes];
}


- (NSArray *)arrayByRemovingObjectsOfClass:(Class)aClass
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    [array removeObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:aClass]) {
            return YES;
        }
        else return NO;
    }];
    return [[NSArray alloc] initWithArray:array];
}


- (NSArray *)arrayByKeepingObjectsOfClass:(Class)aClass
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    [array removeObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:aClass]) {
            return NO;
        }
        else return YES;
    }];
    return [[NSArray alloc] initWithArray:array];
}


- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)otherArray
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![otherArray containsObject:evaluatedObject];
    }];
    return [self filteredArrayUsingPredicate:predicate];
}


- (id)objectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSUInteger index = [self indexOfObjectPassingTest:predicate];
    if (index != NSNotFound) {
        return self[index];
    }
    return nil;
}


- (id)nullableObjectAtIndex:(NSInteger)index
{
    if (index < 0) {
        return nil;
    }
    if (index >= self.count) {
        return nil;
    }
    return self[index];
}


- (NSArray *)transformedArrayUsingHandler:(id (^)(id originalObject, NSUInteger index))handler
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSInteger i = 0; i < [self count]; i++) {
        id resultObject = handler(self[i], i);
        if (resultObject == nil) {
            continue;
        }
        [tempArray addObject:resultObject];
    }
    return [NSArray arrayWithArray:tempArray];
}


- (NSString *)mmh_JSONString
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0
                                                     error:&error];
    if (error) {
        NSLog(@"ERROR: cannot convert array to JSON string: %@", self);
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


- (void)setCenterY:(CGFloat)centerY {
    if (self.count == 0) {
        return;
    }

    for (id object in self) {
        if (![object isKindOfClass:[UIView class]]) {
            return;
        }
    }

    if (self.count > 1) {
        UIView *firstView = self.firstObject;
        for (NSInteger i = 1; i < self.count; i++) {
            UIView *view = [self nullableObjectAtIndex:i];
            if (view == nil) {
                continue;
            }

            if (firstView.superview != view.superview) {
                return;
            }
        }
    }

    CGFloat min = CGFLOAT_MAX;
    CGFloat max = 0.0f;
    for (UIView *view in self) {
        min = MIN(min, CGRectGetMinY(view.frame));
        max = MAX(max, CGRectGetMaxY(view.frame));
    }
    CGFloat currentCenterY = (min + max) * 0.5f;
    CGFloat distance = centerY - currentCenterY;
    if (distance == 0.0f) {
        return;
    }

    for (UIView *view in self) {
        CGFloat viewCenterY = floor(view.centerY + distance);
        [view setCenterY:viewCenterY];
    }
}


@end


@implementation NSMutableArray (MamHao)


+ (NSMutableArray *)nullArrayWithCapacity:(NSUInteger)capacity
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:capacity];
    for (NSInteger i = 0; i < capacity; i++) {
        [array addObject:[NSNull null]];
    }
    return array;
}


- (void)removeObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:predicate];
    [self removeObjectsAtIndexes:indexes];
}


- (void)removeLatterObjectsToKeepObjectsNoMoreThan:(NSInteger)maxCount
{
    if ([self count] > maxCount) {
        [self removeObjectsInRange:NSMakeRange(maxCount, [self count] - maxCount)];
    }
}


- (void)replaceObject:(id)anObject withObject:(id)anotherObject
{
    NSInteger index = [self indexOfObject:anObject];
    if (index != NSNotFound) {
        [self replaceObjectAtIndex:index withObject:anotherObject];
    }
}


- (void)insertUniqueObject:(id)anObject
{
    [self insertUniqueObject:anObject atIndex:[self count]];
}


- (void)insertUniqueObject:(id)anObject atIndex:(NSInteger)index
{
    for (id object in self) {
        if ([object isEqual:anObject]) {
            return;
        }
    }
    if (index < 0 || index > [self count]) {
        return;
    }
    [self insertObject:anObject atIndex:index];
}


- (void)insertUniqueObjectsFromArray:(NSArray *)otherArray
{
    NSArray *objectsToInsert = [otherArray arrayByRemovingObjectsFromArray:self];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [objectsToInsert count])];
    [self insertObjects:objectsToInsert atIndexes:indexSet];
}


- (void)appendUniqueObjectsFromArray:(NSArray *)otherArray
{
    NSArray *objectsToAppend = [otherArray arrayByRemovingObjectsFromArray:self];
    [self addObjectsFromArray:objectsToAppend];
}


- (void)addNullableObject:(id)anObject
{
    if (anObject == nil) {
        return;
    }
    
    [self addObject:anObject];
}


- (void)moveObject:(id)object toIndex:(NSInteger)index
{
    if (index < 0) {
        return;
    }
    
    if (index >= [self count]) {
        return;
    }
    
    NSInteger originIndex = [self indexOfObject:object];
    if (originIndex == NSNotFound) {
        return;
    }
    
    if (originIndex == index) {
        return;
    }
    
    [self removeObject:object];
    [self insertObject:object atIndex:index];
}

- (BOOL)appendObjectsInLastPageFromArray:(NSArray *)otherArray withPageSize:(NSUInteger)size {
    NSInteger loc = (NSInteger)(self.count % size);
    NSInteger len = otherArray.count - loc;
    
    if (loc < 0 || loc > otherArray.count - 1 || len < 0) {
        return NO;
    }
    
    NSArray *appendArr = [otherArray subarrayWithRange:NSMakeRange(loc, len)];
    [self addObjectsFromArray:appendArr];
    return YES;
}

@end


@implementation NSDictionary (MamHao)


- (id)objectForKeys:(NSArray *)keys {
    for (id aKey in keys) {
        if ([self hasKey:aKey]) {
            return self[aKey];
        }
    }
    return nil;
}


- (NSString *)stringRepresentationByURLEncoding
{
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [self allKeys])
    {
        id object = [self objectForKey:key];
        if (![object isKindOfClass:[NSString class]]) {
            continue;
        }
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [object URLEncodedString]]];
    }
    return [pairs componentsJoinedByString:@"&"];
}


- (NSString *)stringForKey:(id)key
{
    id object = [self objectForKey:key];
    if (object == nil) {
        return @"";
    }
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", object];
    }
    if (![object isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", object];
    }
    return object;
}


- (NSInteger)integerForKey:(id)key
{
    id object = self[key];
    if ([object respondsToSelector:@selector(integerValue)]) {
        return [object integerValue];
    }
    return 0;
}


- (double)doubleForKey:(NSString *)key
{
    id object = self[key];
    if ([object respondsToSelector:@selector(doubleValue)]) {
        return [object doubleValue];
    }
    return 0.0;
}


- (NSString *)mmh_JSONString
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0
                                                     error:&error];
    if (error) {
        NSLog(@"ERROR: cannot convert dictionary to JSON string: %@", self);
        return nil;
    }

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


- (BOOL)hasKey:(id)key {
    return [self.allKeys containsObject:key];
}


- (NSDate *)dateForKey:(NSString *)key {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:[self stringForKey:key]];
    return date;
}

@end


@implementation NSMutableDictionary (MamHao)


- (void)setNullableObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (anObject == nil) {
        return;
    }
    
    self[aKey] = anObject;
}


@end


@implementation NSURL (MamHao)


- (NSDictionary *)queryParameters
{
    NSString *query = self.query;
    NSArray *components = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    for (NSString *component in components) {
        NSArray *pair = [component componentsSeparatedByString:@"="];
        if (pair.count != 2) {
            continue;
        }
        NSString *key = pair[0];
        NSString *value = pair[1];
        parameters[key] = value;
    }
    return parameters;
}

- (NSURL *)URLByAppendingQueryParameters:(NSDictionary *)parameters {
    if (parameters.count == 0) {
        return self;
    }
    
    NSMutableArray *componts = [NSMutableArray array];
    NSMutableDictionary *originQueryParameters = [[self queryParameters] mutableCopy];
    [originQueryParameters addEntriesFromDictionary:parameters];
    [originQueryParameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [componts addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    NSString *newQueryString = [componts componentsJoinedByString:@"&"];
    
    NSString *originalURLString = self.absoluteString;
    NSString *originalQuery = self.query;
    NSString *newURLString = nil;
    if (originalQuery.length == 0) {
        newURLString = [originalURLString stringByAppendingString:[NSString stringWithFormat:@"?%@", newQueryString]];
    } else {
        newURLString =  [originalURLString stringByReplacingOccurrencesOfString:originalQuery withString:newQueryString];
    }
    
    NSURL *newUrl = [NSURL URLWithString:newURLString];

    return newUrl;
}

@end


@implementation NSError (MamHao)


//+ (NSError *)mamahaoErrorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription {
//    return [NSError errorWithDomain:MMHErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: localizedDescription}];
//}
//
//
- (NSString *)displayDescription
{
    NSString *displayDescription = @"网络在沉睡，先唤醒再试试~";
//    if ([self.domain isEqualToString:MMHErrorDomain]) {
        displayDescription = [self localizedDescription];
//    }
    return displayDescription;
}


@end


@implementation UIColor (MamHao)


+ (UIColor *)colorWithIntegerRed:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b
{
    return [UIColor colorWithRed:((CGFloat)(r) / 255.0f) green:((CGFloat)(g) / 255.0f) blue:((CGFloat)(b) / 255.0f) alpha:1.0f];
}


+ (UIColor *)colorWithHexString:(NSString *)string
{
    NSString *pureHexString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([pureHexString length] != 6) {
        return [UIColor whiteColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [pureHexString substringWithRange:range];
    
    range.location += range.length ;
    NSString *gString = [pureHexString substringWithRange:range];
    
    range.location += range.length ;
    NSString *bString = [pureHexString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+ (UIColor *)mamhaoMainColor
{
    return [UIColor colorWithHexString:@"ff4d61"];
}


@end


@implementation UIFont (MamHao)


+ (NSArray *)allFontsWithSize:(CGFloat)fontSize
{
    NSMutableArray *fonts = [NSMutableArray array];
    NSArray *familyNames = [UIFont familyNames];
    for (NSString *familyName in familyNames) {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for (NSString *fontName in fontNames) {
            UIFont *font = [UIFont fontWithName:fontName size:16.0f];
            [fonts addObject:font];
        }
    }
    return [NSArray arrayWithArray:fonts];
}


+ (UIFont *)avenirMediumFontWithSize:(CGFloat)fontSize;
{
    return [UIFont fontWithName:@"Avenir-Medium" size:fontSize];
}


+ (UIFont *)avenirBookFontWithSize:(CGFloat)fontSize;
{
    return [UIFont fontWithName:@"Avenir-Light" size:fontSize];
}


+ (UIFont *)helveticaNeueThinFontWithSize:(CGFloat)fontSize
{
    return [self fontWithName:@"HelveticaNeue-Thin" size:fontSize];
}


+ (UIFont *)helveticaNeueLightFontWithSize:(CGFloat)fontSize
{
    return [self fontWithName:@"HelveticaNeue-Light" size:fontSize];
}


+ (UIFont *)helveticaNeueFontWithSize:(CGFloat)fontSize
{
    return [self fontWithName:@"HelveticaNeue" size:fontSize];
}


+ (UIFont *)helveticaNeueUltraLightFontWithSize:(CGFloat)fontSize
{
    return [self fontWithName:@"HelveticaNeue-UltraLight" size:fontSize];
}


+ (UIFont *)systemFontOfCustomeSize:(CGFloat)fontSize
{
    return [self systemFontOfSize:MMHFontSize(fontSize)];
}


+ (UIFont *)boldSystemFontOfCustomeSize:(CGFloat)fontSize
{
    return [self boldSystemFontOfSize:MMHFontSize(fontSize)];
}


@end


@implementation UIImage (MamHao)


- (UIImage *)imageInRect:(CGRect)aRect
{
    CGImageRef cg = self.CGImage;
    CGFloat scale = self.scale;
    CGRect rectInCGImage = CGRectMake(aRect.origin.x * scale, aRect.origin.y * scale, aRect.size.width * scale, aRect.size.height * scale);
    CGImageRef newCG = CGImageCreateWithImageInRect(cg, rectInCGImage);
    UIImage *image = [UIImage imageWithCGImage:newCG scale:scale orientation:self.imageOrientation];
    CGImageRelease(newCG);
    return image;
}


- (UIImage *)centerSquareImage
{
    CGImageRef cg = self.CGImage;
    size_t width = CGImageGetWidth(cg);
    size_t height = CGImageGetHeight(cg);
    size_t length = MIN(width, height);
    CGRect rect = CGRectMake(((width / 2.0f) - (length / 2.0f)), ((height / 2.0f) - (length / 2.0f)), length, length);
    CGImageRef newCG = CGImageCreateWithImageInRect(cg, rect);
    UIImage *image = [UIImage imageWithCGImage:newCG scale:mmh_screen_scale() orientation:self.imageOrientation];
    CGImageRelease(newCG);
    return image;
}


- (UIImage *)imageScaledToFitUploadSize
{
    UIImage *imageWithoutScale = [UIImage imageWithCGImage:self.CGImage scale:1.0f orientation:self.imageOrientation];
    CGSize size = imageWithoutScale.size;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return self;
    }
    
    if ((size.width * size.height) <= 320000.0f) {
        return self;
    }
    
    CGFloat scale = sqrtf(320000.0f / size.width / size.height);
    CGSize newSize = CGSizeMake(ceilf(size.width * scale), ceilf(size.height * scale));
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0f);
    [imageWithoutScale drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)]; // the actual scaling happens here, and orientation is taken care of automatically.
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)scaledToFitSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius {
    return [self imageByRoundCornerRadius:radius borderWidth:0 borderColor:nil];
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor {
    return [self imageByRoundCornerRadius:radius
                                  corners:UIRectCornerAllCorners
                              borderWidth:borderWidth
                              borderColor:borderColor
                           borderLineJoin:kCGLineJoinMiter];
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin {
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)retina4CompatibleImageNamed:(NSString *)imageName
{
    if (kScreenIs4InchRetina) {
        NSString *retina4ImageName = [imageName stringByAppendingString:@"-568h"];
        return [UIImage imageNamed:retina4ImageName];
    }
    else {
        return [UIImage imageNamed:imageName];
    }
}


+ (UIImage *)patternImageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1.0f, 1.0f), NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color set];
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, 1.0f, 1.0f));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (UIImage *)orientationFixedImage
{
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0.0f);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0.0f, self.size.height);
            transform = CGAffineTransformRotate(transform, - M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0.0f);
            transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0.0f);
            transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0.0f,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0.0f, 0.0f, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


+ (UIImage *)caputureImageForView:(UIView *)view {
    CGRect screenRect = [view bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


@implementation UIImageView (MamHao)


+ (instancetype)imageViewWithImageName:(NSString *)imageName
{
    return [[self alloc] initWithImage:[UIImage imageNamed:imageName]];
}

@end


@implementation UIView (MamHao)


- (void)removeAllSubviews
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}


- (void)addSubviews:(NSArray *)sb
{
    if ([sb count] == 0) {
        return;
    }
    
    [sb enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addSubview:obj];
    }];
}


- (void)addAlwaysFitSubview:(UIView *)subview
{
    [self addAlwaysFitSubview:subview withEdgeInsets:UIEdgeInsetsZero];
}


- (void)addAlwaysFitSubview:(UIView *)subview withEdgeInsets:(UIEdgeInsets)edgeInsets
{
    subview.frame = CGRectMake(self.bounds.origin.x + edgeInsets.left,
                               self.bounds.origin.y + edgeInsets.top,
                               self.bounds.size.width - edgeInsets.left - edgeInsets.right,
                               self.bounds.size.height - edgeInsets.top - edgeInsets.bottom);
    if (NSClassFromString(@"NSLayoutConstraint")) {
        [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:subview];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:edgeInsets.left]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f
                                                          constant:(edgeInsets.right * -1.0f)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:edgeInsets.top]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f
                                                          constant:(edgeInsets.bottom * -1.0f)]];
    }
    else {
        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:subview];
    }
}


- (void)bringToFront
{
    [self.superview bringSubviewToFront:self];
}


- (void)sendToBack
{
    [self.superview sendSubviewToBack:self];
}


- (CGFloat)height
{
    return self.frame.size.height;
}


- (CGFloat)width
{
    return self.frame.size.width;
}


- (CGPoint)origin {
    return self.frame.origin;
}


- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGSize)size {
    return self.frame.size;
}


- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (CGFloat)x
{
    return self.frame.origin.x;
}


- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (CGFloat)y
{
    return self.frame.origin.y;
}


- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


- (void)setMaxX:(CGFloat)maxX
{
    CGRect frame = self.frame;
    frame.size.width = maxX - frame.origin.x;
    self.frame = frame;
}


- (void)setMaxY:(CGFloat)maxY
{
    CGRect frame = self.frame;
    frame.size.height = maxY - frame.origin.y;
    self.frame = frame;
}


- (void)moveXOffset:(CGFloat)xOffset
{
    CGRect frame = self.frame;
    frame.origin.x += xOffset;
    self.frame = frame;
}


- (void)moveYOffset:(CGFloat)yOffset
{
    CGRect frame = self.frame;
    frame.origin.y += yOffset;
    self.frame = frame;
}


- (void)moveToCenterOfSuperview
{
    self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
}


- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}


- (CGFloat)top
{
    return self.frame.origin.y;
}


- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}


- (void)moveToBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}


- (CGFloat)centerX
{
    return self.center.x;
}


- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}


- (CGFloat)centerY
{
    return self.center.y;
}


- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}


- (CGFloat)left
{
    return self.frame.origin.x;
}


- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}


- (void)moveToRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


- (void)attachToLeftSideOfView:(UIView *)otherView byDistance:(CGFloat)distance
{
    [self moveToRight:otherView.left - distance];
}


- (void)attachToRightSideOfView:(UIView *)otherView byDistance:(CGFloat)distance
{
    [self setLeft:otherView.right + distance];
}


- (void)attachToBottomSideOfView:(UIView *)otherView byDistance:(CGFloat)distance
{
    [self setTop:otherView.bottom + distance];
}


- (UIImage *)snapshotWithScale:(CGFloat)scale
{
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


- (void)makeRoundedRectangleShape
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat length = MIN(width, height);
    self.layer.cornerRadius = length * 0.5f;
    self.clipsToBounds = YES;
}


- (void)setBorderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius
{
    if (borderColor != nil) {
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = 1.0f / mmh_screen_scale();
    }
    self.layer.cornerRadius = cornerRadius;
}


- (void)addTopLeftRoundingCornerWithLength:(CGFloat)length {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft
                                                         cornerRadii:CGSizeMake(length, length)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


- (void)addTopSeparatorLine {
    [self addTopSeparatorLineWithPadding:0.0f];
}

- (void)removeTopSeparatorLine{
    UIView *topLine = [self viewWithStringTag:@"topLine"];
    if (topLine) {
        [topLine removeFromSuperview];
    }
}

- (void)addTopSeparatorLineWithPadding:(CGFloat)padding {
    CGFloat pixel = 1.0f / mmh_screen_scale();
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + padding, 0.0f, self.bounds.size.width - padding - padding, pixel)];
    topLine.stringTag = @"topLine";
    topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    topLine.backgroundColor = [QGHAppearance separatorColor];
    [self addSubview:topLine];
}


- (void)removeBottomSeparatorLine{
    UIView *bottomLine = [self viewWithStringTag:@"bottomSeparatorLine"];
    if (bottomLine) {
        [bottomLine removeFromSuperview];
    }
}

- (void)addBottomSeparatorLine
{
    CGFloat pixel = 1.0f / mmh_screen_scale();
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, CGRectGetMaxY(self.bounds) - pixel, self.bounds.size.width, pixel)];
    bottomLine.stringTag = @"bottomSeparatorLine";
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    bottomLine.backgroundColor = [QGHAppearance separatorColor];
    [self addSubview:bottomLine];
}

- (void)addBottomSeparatorLineWithPadding:(CGFloat)padding
{
    CGFloat pixel = 1.0f / mmh_screen_scale();
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + padding, CGRectGetMaxY(self.bounds) - pixel, self.bounds.size.width - padding - padding, pixel)];
    bottomLine.stringTag = @"bottomSeparatorLine";
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    bottomLine.backgroundColor = [QGHAppearance separatorColor];
    [self addSubview:bottomLine];
}

- (void)showProcessingView
{
//    CGPoint point = [[UIApplication sharedApplication].keyWindow convertPoint:[UIApplication sharedApplication].keyWindow.center toView:self];
//    CGFloat offset = [UIApplication sharedApplication].keyWindow.rootViewController.view.centerY - point.y;
//    NSLogPoint(point);
//    NSLog(@"%f",-offset);

//    CGRect rectInWindow = [[UIApplication sharedApplication].keyWindow convertRect:self.frame fromView:self.superview];
//    CGFloat centerYInWindow = rectInWindow.origin.y + rectInWindow.size.height * 0.5;
//    CGFloat offset = [UIApplication sharedApplication].keyWindow.height * 0.5 - centerYInWindow;
    
    [self showProcessingViewWithYOffset:-80.0f];
}


- (void)showProcessingViewWithYOffset:(CGFloat)yOffset
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.yOffset = yOffset;
    hud.tag = 10086;
    hud.mode = MBProgressHUDModeIndeterminate;
}


- (void)hideProcessingView
{
    BOOL hide = [MBProgressHUD hideHUDForView:self animated:NO];
    while (hide) {
        hide = [MBProgressHUD hideHUDForView:self animated:NO];
    }
}


- (void)showProcessingViewWithMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.yOffset = MMHFloat(-80.0f);
    hud.labelFont = [UIFont systemFontOfSize:12.0f];
    hud.tag = 10086;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
}


- (void)showTips:(NSString *)tips {
    [self showTips:tips completion:nil];
}


- (void)showTips:(NSString *)tips completion:(dispatch_block_t)completion {
    [self hideProcessingView];
    
    if ([tips isKindOfClass:[NSNull class]] || [tips length] == 0) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.yOffset = MMHFloat(0.0f);
    hud.detailsLabelFont = [UIFont systemFontOfSize:12.0f];
//    hud.tag = 10086;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = tips;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hide:YES];
        if (completion) {
            completion();
        }
    });
}


- (void)showTipsWithError:(NSError *)error inCenterOfSuperView:(UIView *)view{
    if (error == nil) {
        return;
    }
    NSString *tips = @"网络在沉睡，先唤醒再试试~";
//    if ([error.domain isEqualToString:MMHErrorDomain]) {
        tips = [error localizedDescription];
//    }
    if ([tips length] == 0) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.xOffset = MMHFloat(0);
    hud.labelFont = [UIFont systemFontOfSize:12.0f];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tips;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hide:YES];
    });

}


- (void)showTipsWithError:(NSError *)error
{
    if (error == nil || [error isKindOfClass:[NSNull class]]) {
        return;
    }
    
    NSString *tips = [error displayDescription];
    [self showTips:tips];
}


- (void)showTipsOfNetworkUnreachable
{
    NSString *tips = @"网络在沉睡，先唤醒再试试~";
    [self showTips:tips];
}


@end


@implementation UILabel (MamHao)


- (void)setFontSize:(NSInteger)size
{
    self.font = [UIFont systemFontOfSize:size];
}


- (void)setTextWithDate:(NSDate *)date dateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = nil;
    if (format == nil) {
        dateFormat = @"yyyy.MM.dd HH: mm: ss";
    } else {
        dateFormat = format;
    }
    formatter.dateFormat = dateFormat;
    NSString *dateString = [formatter stringFromDate:date];
    self.text = dateString;
}


- (void)updateHeight
{
    [self setText:self.text constrainedToLineCount:self.numberOfLines];
}


- (BOOL)setText:(NSString *)text constrainedToLineCount:(NSUInteger)maxLineCount
{
    BOOL constrained = NO;
    CGFloat height = [text heightWithFont:self.font constrainedToWidth:self.bounds.size.width lineCount:maxLineCount constrained:&constrained];
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    self.numberOfLines = maxLineCount;
    self.text = text;
    return constrained;
}


- (void)setSingleLineText:(NSString *)text
{
    [self setSingleLineText:text constrainedToWidth:CGFLOAT_MAX];
}


- (void)setSingleLineText:(NSString *)text constrainedToWidth:(CGFloat)maxWidth
{
    [self setSingleLineText:text constrainedToWidth:maxWidth keepingHeight:NO];
}


- (void)setSingleLineText:(NSString *)text keepingHeight:(BOOL)keepingHeight
{
    [self setSingleLineText:text constrainedToWidth:CGFLOAT_MAX keepingHeight:keepingHeight];
}


- (void)setSingleLineText:(NSString *)text constrainedToWidth:(CGFloat)maxWidth keepingHeight:(BOOL)keepingHeight
{
    CGFloat height = self.height;
    [self setSingleLineText:text constrainedToWidth:maxWidth withEdgeInsets:UIEdgeInsetsZero];
    if (keepingHeight) {
        self.height = height;
    }
}


- (void)setSingleLineText:(NSString *)text constrainedToWidth:(CGFloat)maxWidth withEdgeInsets:(UIEdgeInsets)edgeInsets {
    [self setSingleLineText:text constrainedToWidth:maxWidth withEdgeInsets:edgeInsets keepingHeight:NO];
}


- (void)setSingleLineText:(NSString *)text withEdgeInsets:(UIEdgeInsets)edgeInsets keepingHeight:(BOOL)keepingHeight {
    [self setSingleLineText:text constrainedToWidth:CGFLOAT_MAX withEdgeInsets:edgeInsets keepingHeight:keepingHeight];
}


- (void)setSingleLineText:(NSString *)text constrainedToWidth:(CGFloat)maxWidth withEdgeInsets:(UIEdgeInsets)edgeInsets keepingHeight:(BOOL)keepingHeight
{
    if (![text isKindOfClass:[NSString class]]) {
        text = @" ";
    }
    
    NSStringDrawingOptions options = 0;
    NSDictionary *attributes = @{NSFontAttributeName: self.font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                     options:options
                                  attributes:attributes
                                     context:nil].size;
    
//    CGSize size = [text sizeWithFont:self.font
//                            forWidth:maxWidth
//                       lineBreakMode:NSLineBreakByWordWrapping];
    size.width += edgeInsets.left + edgeInsets.right;
    if (!keepingHeight) {
        size.height += edgeInsets.top + edgeInsets.bottom;
    }
    else {
        size.height = self.frame.size.height;
    }
    size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    CGFloat offsetX = self.frame.size.width - size.width;
    [self setSize:size];
    switch (self.textAlignment) {
        case NSTextAlignmentLeft:
            break;
        case NSTextAlignmentCenter:
            [self moveXOffset:(offsetX * 0.5f)];
            break;
        case NSTextAlignmentRight:
            [self moveXOffset:(offsetX)];
            break;
        default:
            break;
    }
    self.numberOfLines = 1;
    self.text = text;
}

- (void)setSingleVerticalLineChineseText:(NSString *)text {
    self.numberOfLines = text.length;
    NSDictionary *attributes = @{NSFontAttributeName : self.font};
    NSString *baseText = @"果";
    CGSize baseSize = [baseText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attributes context:nil].size;
    CGSize size = [text sizeWithCalcFont:self.font constrainedToSize:CGSizeMake(baseSize.width, CGFLOAT_MAX)];
    self.size = CGSizeMake(ceil(baseSize.width), ceil(size.height));
    self.text = text;
}

- (void)setTextColor:(UIColor *)color inRange:(NSRange)range
{
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}


- (void)setTextColor:(UIColor *)color forSubstring:(NSString *)substring
{
    NSRange range = [self.text rangeOfString:substring];
    [self setTextColor:color inRange:range];
}


- (void)addAttribute:(NSString *)attributeName value:(id)attributeValue range:(NSRange)range {
    if (range.location == NSNotFound) {
        return;
    }
    if (range.length == 0) {
        return;
    }

    NSAttributedString *text = self.attributedText;
    if (text.length <= range.location) {
        return;
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text];
    [attributedString addAttribute:attributeName
                             value:attributeValue
                             range:range];
    self.attributedText = attributedString;
}


- (void)addStrikethroughLine {
    NSRange range = NSMakeRange(0, self.text.length);
    [self addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
//    [self addAttribute:NSStrokeColorAttributeName value:self.textColor range:range];
}


@end


@implementation UIButton (MamHao)


+ (id)buttonWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName alwaysRenderingAsTemplate:(BOOL)alwaysRenderingAsTemplate title:(NSString *)title target:(id)target action:(SEL)action
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *highlightedImage = [UIImage imageNamed:highlightedImageName];
    if (alwaysRenderingAsTemplate) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        highlightedImage = [highlightedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    CGSize imageSize = [image size];
    CGSize highlightedImageSize = [highlightedImage size];
    if (highlightedImageName != nil) {
        if (!image || !highlightedImage) {
            return nil;
        }
        if (!CGSizeEqualToSize(imageSize, highlightedImageSize)) {
            return nil;
        }
    }
    else {
        if (!image) {
            return nil;
        }
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height)];
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [button setBackgroundImage:image forState:UIControlStateNormal];
    if (highlightedImageName) {
        [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


- (void)makeVerticalWithPadding:(CGFloat)padding
{
    UIImageView *imageView = self.imageView;
    UILabel *titleLabel = self.titleLabel;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(padding * - 0.5f, (titleLabel.bounds.size.width ) * 0.5f, titleLabel.frame.size.height, (titleLabel.bounds.size.width) * -0.5f);
    self.titleEdgeInsets = UIEdgeInsetsMake(imageView.frame.size.height, (imageView.frame.size.width) * -0.5f, padding * - 0.5f, imageView.frame.size.width * 0.5f);
}


@end


@implementation UITextField (MamHao)


- (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacters
{
    return self.text == nil || [self.text isEmptyAfterTrimmingWhitespaceAndNewlineCharacters];
}


- (NSString *)nonNilText
{
    NSString *text = self.text;
    if (text == nil) {
        return @"";
    }
    return text;
}


- (NSInteger)textLengh
{
    return self.text.length;
}


@end


@implementation UITextView (MamHao)


- (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacters
{
    return self.text == nil || [self.text isEmptyAfterTrimmingWhitespaceAndNewlineCharacters];
}


- (CGFloat)textHeight
{
    CGSize sizeThatFits = [self sizeThatFits:self.bounds.size];
    return ceilf(sizeThatFits.height);
    if (YES) {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = self.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = self.textContainerInset;
        UIEdgeInsets contentInsets = self.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + self.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = self.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", self.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: self.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else {
        return self.contentSize.height;
    }
}


@end


@implementation UIBarButtonItem (MamHao)


+ (id)itemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithImageName:imageName highlightedImageName:highlightedImageName alwaysRenderingAsTemplate:YES title:(NSString *)title target:target action:action];
    if (button == nil) {
        return nil;
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (id)itemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithImageName:imageName highlightedImageName:highlightedImageName alwaysRenderingAsTemplate:YES title:(NSString *)title target:target action:action];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    if (button == nil) {
        return nil;
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


@end


@implementation UIViewController (MamHao)


static const void *HttpRequestHUDKey = &HttpRequestHUDKey;



- (void)popWithAnimation
{
    if (self.navigationController.visibleViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)dismissViewControllerWithAnimation
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}

- (void)showHint:(NSString *)hint
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = MMHFloat(150.0f);
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = MMHFloat(150.0f);
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)hideHud{
    [[self HUD] hide:YES];
}


@end


@implementation UINavigationController (MamHao)


- (void)popToViewControllerOfClass:(Class)aClass {
    if (aClass == nil) {
        return;
    }

    NSUInteger index = [self.viewControllers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:aClass]) {
                return YES;
            }
            return NO;
        }];
    if (index == NSNotFound) {
        return;
    }

    NSArray *viewControllers = [self.viewControllers subarrayWithRange:NSMakeRange(0, index + 1)];
    [self setViewControllers:viewControllers animated:YES];
}


@end


@implementation UITableView (MamHao)


- (NSIndexPath *)lastIndexPath
{
    NSInteger numberOfSections = [self numberOfSections];
    if (numberOfSections == 0) {
        return nil;
    }
    NSInteger lastSection = numberOfSections - 1;
    
    NSInteger numberOfRowsInLastSection = [self numberOfRowsInSection:lastSection];
    if (numberOfRowsInLastSection == 0) {
        return nil;
    }
    NSInteger lastRow = numberOfRowsInLastSection - 1;
    return [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
}


- (void)scrollToLastRowAnimated:(BOOL)animated
{
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    [self scrollToRowAtIndexPath:lastIndexPath
                atScrollPosition:UITableViewScrollPositionBottom
                        animated:animated];
}


- (BOOL)lastCellVisible
{
    NSArray *visibleIndexPaths = [self indexPathsForVisibleRows];
    if ([visibleIndexPaths containsObject:[self lastIndexPath]]) {
        return YES;
    }
    return NO;
}


- (void)setTableViewSeparatorInsets:(UIEdgeInsets)insets {
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:insets];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:insets];
    }
}

@end


@implementation UITableViewCell (MamHao)

- (void)setCellSeparatorInsets:(UIEdgeInsets)insets {
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:insets];
    }
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:insets];
    }
}

@end


@implementation UIApplication (MamHao)


- (void)clearNotificationMark
{
    [self setApplicationIconBadgeNumber:1];
    [self setApplicationIconBadgeNumber:0];
    NSArray* scheduledNotifications = [NSArray arrayWithArray:self.scheduledLocalNotifications];
    self.scheduledLocalNotifications = scheduledNotifications;
    [self cancelAllLocalNotifications];
}


+ (void)tryToCallPhoneNumber:(NSString *)phoneNumber
{
    NSString *urlString = [NSString stringWithFormat:@"tel://%@", phoneNumber];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[self sharedApplication] canOpenURL:url]) {
        [[self sharedApplication] openURL:url];
//        LESAlertView *alertView = [[LESAlertView alloc] initWithTitle:@"电话"
//                                                              message:[NSString stringWithFormat:@"拨打 %@", phoneNumber]
//                                                    cancelButtonTitle:@"取消"
//                                                  cancelButtonHandler:^{
//
//                                                  }];
//        [alertView addButtonWithTitle:@"确定" handler:^{
//            [[self sharedApplication] openURL:url];
//        }];
//        [alertView show];
    }
    else {
//        [LESAlertView showWithTitle:@"电话"
//                            message:@"您的设备不能拨打电话"
//                  cancelButtonTitle:@"确定"
//                cancelButtonHandler:^{
//
//                }];
    }
}


@end


@implementation UIScreen (MamHao)


+ (LESScreenMode)currentScreenMode
{
    CGSize currentSize = [UIScreen mainScreen].bounds.size;
//    CGFloat currentScale = [UIScreen mainScreen].scale;
    
    if (CGSizeEqualToSize(currentSize, CGSizeMake(320.0f, 480.0f))) {
        return LESScreenModeIPhone4SOrEarlier;
    }
    else if (CGSizeEqualToSize(currentSize, CGSizeMake(320.0f, 568.0f))) {
        return LESScreenModeIPhone5Series;
    }
    else if (CGSizeEqualToSize(currentSize, CGSizeMake(375.0f, 667.0f))) {
        return LESScreenModeIPhone6;
    }
    else if (CGSizeEqualToSize(currentSize, CGSizeMake(414.0f, 736.0f))) {
        return LESScreenModeIPhone6Plus;
    }
    else if (CGSizeEqualToSize(currentSize, CGSizeMake(768.0f, 1024.0f))) {
        return LESScreenModeIPadPortrait;
    }
    else if (CGSizeEqualToSize(currentSize, CGSizeMake(1024.0f, 768.0f))) {
        return LESScreenModeIPadLandscape;
    }
    
    return LESScreenModeUnknown;
}


@end


@implementation NSDate (MamHao)


- (NSString *)stringRepresentationWithDateFormat:(NSString *)format
{
    static NSDateFormatter *formatter_ = nil;
    formatter_ = [[NSDateFormatter alloc] init];
    NSString *dateFormat = nil;
    if (format == nil) {
        dateFormat = @"yyyy.MM.dd HH: mm: ss";
    } else {
        dateFormat = format;
    }
    formatter_.dateFormat = dateFormat;
    NSString *dateString = [formatter_ stringFromDate:self];
    return dateString;
}


+ (NSDate *)dateWithTimestamp:(NSTimeInterval)timestamp
{
    NSTimeInterval t = timestamp / 1000.0;
    return [NSDate dateWithTimeIntervalSince1970:t];
}

+ (NSDate *)dateWithString:(NSString *)timeStr withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSDate *date = [dateFormatter dateFromString:timeStr];
    return date;
}

- (BOOL)earlierThan:(NSDate *)otherDate
{
    return ([self compare:otherDate] == NSOrderedAscending);
}


- (BOOL)laterThan:(NSDate *)otherDate
{
    return ([self compare:otherDate] == NSOrderedDescending);
}

//获取日
- (NSUInteger)getDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];
    return [dateComponents day];
}
//获取月
- (NSUInteger)getMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];
    return [dateComponents month];
}
//获取年
- (NSUInteger)getYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];
    return [dateComponents year];
}
//获取小时
- (NSUInteger)getHour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger hour = [components hour];
    return (int)hour;
}
//获取分钟
- (NSUInteger)getMinute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger minute = [components minute];
    return (int)minute;
}


@end


@implementation NSData (MamHao)


- (NSString *)md5String
{
    unsigned char result[16];
    CC_MD5( self.bytes, (CC_LONG)(self.length), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


@end


@implementation NSFileManager (MamHao)

+ (void)setExcludedFromBackup:(BOOL)excluded forFileAtpath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    NSString *currentSystemVersion = kSystemVersion;
    if ([currentSystemVersion compare:@"5.1"] != NSOrderedAscending) {
        [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
    else if ([currentSystemVersion compare:@"5.0.1"] != NSOrderedAscending) {
        const char* filePath = [[url path] fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    }
}


- (unsigned long long int)documentsFolderSize:(NSString *)documentPath
{
    NSString *_documentsDirectory = documentPath;
    NSArray *_documentsFileList;
    NSEnumerator *_documentsEnumerator;
    NSString *_documentFilePath;
    unsigned long long int _documentsFolderSize = 0;
    
    _documentsFileList = [self subpathsAtPath:_documentsDirectory];
    _documentsEnumerator = [_documentsFileList objectEnumerator];
    while (_documentFilePath = [_documentsEnumerator nextObject]) {
        NSDictionary *_documentFileAttributes = [self attributesOfItemAtPath:[_documentsDirectory stringByAppendingPathComponent:_documentFilePath] error:nil];
        _documentsFolderSize += [_documentFileAttributes fileSize];
    }
    
    return _documentsFolderSize;
}


- (void)removeFileAtPath:(NSString *)path condition:(BOOL (^)(NSString *))block
{
    NSArray *files = [self contentsOfDirectoryAtPath:path error:nil];
    for (NSString *filePath in files) {
        NSString *fullPath = [path stringByAppendingPathComponent:filePath];
        if (block(fullPath)) {
            [self removeItemAtPath:fullPath error:nil];
        }
    }
}


+ (BOOL)removeItemIfExistsAtPath:(NSString *)path error:(NSError **)error
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
    }
    else {
        return NO;
    }
}


@end

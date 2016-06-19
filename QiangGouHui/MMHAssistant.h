//
//  MMHAssistant.h
//  MamHao
//
//  Created by Louis Zhu on 15/4/1.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//#if defined (DEBUG_LOUIS)
//#define LZLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
//#else
//#define     LZLog( s, ... )
//#endif
//
//
//#if defined (DEBUG_ARES)
//#define ARESLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
//#else
//#define     ARESLog( s, ... )
//#endif


extern NSString *const MMHUserDidLoginNotification;
extern NSString *const MMHUserDidLogoutNotification;
extern NSString *const MMHUserPersonalInformationFetchedNotification;
extern NSString *const MMHUserPersonalInformationDidCompleteNotification;
extern NSString *const MMHUserPersonalInformationChangedNotification;

extern NSString *const MMHUnreadMessageCountDidChangeNotification;


extern BOOL MMHUsingAPIMamahaoCom();

extern BOOL CHTIsUserIDAvailableForUserDetail(NSString *userID);

extern BOOL mmh_option_contains_bit(NSUInteger option, NSUInteger bit);


extern CGFloat mmh_screen_scale();
extern CGFloat mmh_screen_width();
extern CGFloat mmh_screen_height();
extern CGFloat mmh_pixel();

#define MMHNavHeight 64
#define MMHTabHeight 45

#define mmh_relative_float MMHFloat
#define mmh_relative_point MMHPoint
#define mmh_relative_size MMHSize
#define mmh_relative_rect MMHRect
#define mmh_relative_point_make MMHPointMake
#define mmh_relative_size_make MMHSizeMake
#define mmh_relative_rect_make MMHRectMake
#define mmh_relative_edgeInsets_make MMHEdgeInsetsMake

#define RGBCOLOR(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

extern CGFloat MMHFloat(CGFloat floatValue);
extern CGFloat MMHFloatWithPadding(CGFloat floatValue, CGFloat padding);
extern CGPoint MMHPoint(CGPoint pointValue);
extern CGSize MMHSize(CGSize sizeValue);
extern CGRect MMHRect(CGRect rectValue);


extern CGPoint MMHPointMake(CGFloat x, CGFloat y);
extern CGSize MMHSizeMake(CGFloat width, CGFloat height);
extern CGRect MMHRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);


extern UIEdgeInsets UIEdgeInsetsWithTop(CGFloat top);
extern UIEdgeInsets UIEdgeInsetsWithLeft(CGFloat left);
extern UIEdgeInsets UIEdgeInsetsWithBottom(CGFloat bottom);
extern UIEdgeInsets UIEdgeInsetsWithRight(CGFloat right);


extern UIEdgeInsets MMHEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);


extern CGFloat MMHFontSize(CGFloat pointSize);
extern UIFont *MMHFontOfSize(CGFloat pointSize);


extern CGSize CGSizePixelToPoint(CGSize sizeOfPixel);
extern CGSize CGSizePointToPixel(CGSize sizeOfPoint);


extern NSString *MMHPathTemp();
extern NSString *MMHPathDocuments();
extern NSString *MMHPathDocumentsAppendingPathComponent(NSString *pathComponent);


@interface NSObject (MamHao)

- (BOOL)notNilOrEmpty;

@end


@interface NSString (MamHao)

//是不是含有表情
- (BOOL)isContainsEmoji:(NSString *)string;
- (BOOL)isPureIntNumber;
- (NSString *)md5String;
- (NSString *)sha1String;
- (NSString *)encryptString;
- (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingWhitespaceAndNewlineCharacters;

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

+ (NSString *)stringWithDate:(NSDate *)date dateFormat:(NSString *)format;

- (NSComparisonResult)versionNumberCompare:(NSString *)string;

// 是否是邮箱
- (BOOL)conformsToEMailFormat;
// 长度是否在一个范围之内,包括范围值
- (BOOL)isLengthGreaterThanOrEqual:(NSInteger)minimum lessThanOrEqual:(NSInteger)maximum;

- (NSRange)firstRangeOfURLSubstring;
- (NSString *)firstURLSubstring;
- (NSString *)firstMatchUsingRegularExpression:(NSRegularExpression *)regularExpression;
- (NSString *)firstMatchUsingRegularExpressionPattern:(NSString *)regularExpressionPattern;
// 注意这个是全文匹配
- (BOOL)matchesRegularExpressionPattern:(NSString *)regularExpressionPattern;
- (BOOL)containInvalidString;
- (NSRange)rangeOfFirstMatchUsingRegularExpressionPattern:(NSString *)regularExpressionPattern;

- (NSString *)stringByReplacingMatchesUsingRegularExpressionPattern:(NSString *)regularExpressionPattern withTemplate:(NSString *)templ;
- (CGSize)sizeWithSingleLineFont:(UIFont *)font;

- (id)jsonObject;

- (BOOL)isChineseCharacter;
- (BOOL)isNumberOrEnglishOrChineseCharacter;
- (BOOL)isPureNumandCharacters;
+ (NSString *)filePathWithName:(NSString *)name;
//+ (NSString *)defautPortraitNameWithUserIdentity:(MMHUserIdentity)userIdentity;
//+ (NSString *)pureStringWithPrice:(MMHPrice)price;
//+ (NSString *)stringWithPrice:(MMHPrice)price;
//+ (NSString *)beanPriceStringWithPrice:(MMHPrice)price beanPrice:(long)beanPrice;
//- (MMHPrice)priceValue;
//+ (NSString *)stringWithMMHID:(MMHID)mmhid;
//- (MMHID)MMHIDValue;
+ (NSString *)stringWithMonthAge:(long)monthAge;
+ (NSString *)stringWithSoldCount:(long)soldCount;
+ (NSString *)stringWithCrowdfundingAmount:(long)crowdfundingAmount;
+ (NSString *)stringWithPureSoldCountString:(NSString *)pureSoldCountString;
+ (NSString *)stringSeparateByCommaFromArray:(NSArray<NSString *> *)array;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)maxWidth lineCount:(NSUInteger)maxLineCount;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)maxWidth lineCount:(NSUInteger)maxLineCount constrained:(BOOL *)constrained;
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)maxWidth lineCount:(NSUInteger)maxLineCount;
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)maxWidth lineCount:(NSUInteger)maxLineCount constrained:(BOOL *)constrained;
@end


@interface NSAttributedString (MamHao)

- (CGFloat)heightConstrainedToWidth:(CGFloat)maxWidth;

@end


@interface NSNumber (MamHao)

//- (MMHPrice)priceValue;
//- (MMHID)MMHIDValue;

@end


@interface NSArray (MamHao)

- (id)firstObject;

- (NSArray *)arrayWithObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)arrayByRemovingObjectsOfClass:(Class)aClass;
- (NSArray *)arrayByKeepingObjectsOfClass:(Class)aClass;
- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)otherArray;

- (id)objectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (id)nullableObjectAtIndex:(NSInteger)index;

- (NSArray *)transformedArrayUsingHandler:(id (^)(id originalObject, NSUInteger index))handler;

- (NSString *)mmh_JSONString;

- (void)setCenterY:(CGFloat)centerY;

@end


@interface NSMutableArray (MamHao)

+ (NSMutableArray *)nullArrayWithCapacity:(NSUInteger)capacity;
- (void)removeObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (void)removeLatterObjectsToKeepObjectsNoMoreThan:(NSInteger)maxCount;
- (void)replaceObject:(id)anObject withObject:(id)anotherObject;
- (void)insertUniqueObject:(id)anObject;
- (void)insertUniqueObject:(id)anObject atIndex:(NSInteger)index;
- (void)insertUniqueObjectsFromArray:(NSArray *)otherArray;
- (void)appendUniqueObjectsFromArray:(NSArray *)otherArray;
- (void)addNullableObject:(id)anObject;

- (void)moveObject:(id)object toIndex:(NSInteger)index;

- (BOOL)appendObjectsInLastPageFromArray:(NSArray *)otherArray withPageSize:(NSUInteger)size;

@end


@interface NSDictionary (MamHao)

- (id)objectForKeys:(NSArray *)keys;

- (NSString *)stringRepresentationByURLEncoding;
- (NSString *)stringForKey:(id)key;

- (NSInteger)integerForKey:(id)key;
- (double)doubleForKey:(NSString *)key;

- (NSString *)mmh_JSONString;

- (BOOL)hasKey:(id)key;

- (NSDate *)dateForKey:(NSString *)key;

@end


@interface NSMutableDictionary (MamHao)

- (void)setNullableObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end


@interface NSURL (MamHao)

- (NSDictionary *)queryParameters;
- (NSURL *)URLByAppendingQueryParameters:(NSDictionary *)parameters;

@end


@interface NSError (MamHao)

//+ (NSError *)mamahaoErrorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription;
//- (NSString *)displayDescription;

@end


@interface UIColor (MamHao)

+ (UIColor *)colorWithIntegerRed:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b;
+ (UIColor *)colorWithHexString:(NSString *)string;

+ (UIColor *)mamhaoMainColor;

@end


@interface UIFont (MamHao)

+ (NSArray *)allFontsWithSize:(CGFloat)fontSize;

+ (UIFont *)avenirMediumFontWithSize:(CGFloat)fontSize;
+ (UIFont *)avenirBookFontWithSize:(CGFloat)fontSize;

+ (UIFont *)helveticaNeueThinFontWithSize:(CGFloat)fontSize;
+ (UIFont *)helveticaNeueLightFontWithSize:(CGFloat)fontSize;
+ (UIFont *)helveticaNeueFontWithSize:(CGFloat)fontSize;
+ (UIFont *)helveticaNeueUltraLightFontWithSize:(CGFloat)fontSize;

+ (UIFont *)systemFontOfCustomeSize:(CGFloat)fontSize;
+ (UIFont *)boldSystemFontOfCustomeSize:(CGFloat)fontSize;

@end


@interface UIImage (MamHao)

// 如果参数比原image的size小，是截取原image相应的rect里的部分，如果参数比原image大，则是白底填充原image
- (UIImage *)imageInRect:(CGRect)aRect;
- (UIImage *)centerSquareImage;
- (UIImage *)imageScaledToFitUploadSize;
- (UIImage *)scaledToFitSize:(CGSize)size;
- (UIImage *)orientationFixedImage;

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius;

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin;

+ (UIImage *)retina4CompatibleImageNamed:(NSString *)imageName;
+ (UIImage *)patternImageWithColor:(UIColor *)color;
+ (UIImage *)caputureImageForView:(UIView *)view;
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end


@interface UIView (MamHao)

- (void)removeAllSubviews;
- (void)addSubviews:(NSArray *)sb;
- (void)addAlwaysFitSubview:(UIView *)subview;
- (void)addAlwaysFitSubview:(UIView *)subview withEdgeInsets:(UIEdgeInsets)edgeInsets;

- (void)bringToFront;
- (void)sendToBack;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
- (void)setMaxX:(CGFloat)maxX;
- (void)setMaxY:(CGFloat)maxY;

- (void)moveXOffset:(CGFloat)xOffset;
- (void)moveYOffset:(CGFloat)yOffset;
- (void)moveToCenterOfSuperview;

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
- (void)moveToBottom:(CGFloat)bottom;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
- (void)moveToRight:(CGFloat)right;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

- (void)attachToLeftSideOfView:(UIView *)otherView byDistance:(CGFloat)distance;
- (void)attachToRightSideOfView:(UIView *)otherView byDistance:(CGFloat)distance;
- (void)attachToBottomSideOfView:(UIView *)otherView byDistance:(CGFloat)distance;

- (UIImage *)snapshotWithScale:(CGFloat)scale;

- (void)makeRoundedRectangleShape;
- (void)setBorderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius;
- (void)addTopLeftRoundingCornerWithLength:(CGFloat)length;

- (void)addTopSeparatorLine;
- (void)addTopSeparatorLineWithPadding:(CGFloat)padding;
- (void)addBottomSeparatorLineWithPadding:(CGFloat)padding;
- (void)addBottomSeparatorLine;
- (void)removeBottomSeparatorLine;
- (void)removeTopSeparatorLine;
- (void)showProcessingView;
- (void)showProcessingViewWithYOffset:(CGFloat)yOffset;
- (void)hideProcessingView;
- (void)showProcessingViewWithMessage:(NSString *)message;
- (void)showTips:(NSString *)tips;
- (void)showTips:(NSString *)tips completion:(dispatch_block_t)completion;
- (void)showTipsWithError:(NSError *)error inCenterOfSuperView:(UIView *)view;
- (void)showTipsWithError:(NSError *)error;
- (void)showTipsOfNetworkUnreachable;
@end


@interface UIImageView (MamHao)

+ (instancetype)imageViewWithImageName:(NSString *)imageName;

@end


@interface UILabel (MamHao)

- (void)setFontSize:(NSInteger)size;
- (void)setTextWithDate:(NSDate *)date dateFormat:(NSString *)format;
//- (CGFloat)heightWithText:(NSString *)text;
- (void)updateHeight;
- (BOOL)setText:(NSString *)text constrainedToLineCount:(NSUInteger)maxLineCount;
- (void)setSingleLineText:(NSString *)text;
- (void)setSingleLineText:(NSString *)text constrainedToWidth:(CGFloat)maxWidth;
- (void)setSingleLineText:(NSString *)text keepingHeight:(BOOL)keepingHeight;
- (void)setSingleLineText:(NSString *)text constrainedToWidth:(CGFloat)maxWidth keepingHeight:(BOOL)keepingHeight;
- (void)setSingleLineText:(NSString *)text constrainedToWidth:(CGFloat)maxWidth withEdgeInsets:(UIEdgeInsets)edgeInsets;
- (void)setSingleLineText:(NSString *)text withEdgeInsets:(UIEdgeInsets)edgeInsets keepingHeight:(BOOL)keepingHeight;
- (void)setSingleLineText:(NSString *)text constrainedToWidth:(CGFloat)maxWidth withEdgeInsets:(UIEdgeInsets)edgeInsets keepingHeight:(BOOL)keepingHeight;
- (void)setSingleVerticalLineChineseText:(NSString *)text;

- (void)setTextColor:(UIColor *)color inRange:(NSRange)range;
- (void)setTextColor:(UIColor *)color forSubstring:(NSString *)substring;
- (void)addAttribute:(NSString *)attributeName value:(id)attributeValue range:(NSRange)range;

- (void)addStrikethroughLine;

@end


@interface UIButton (MamHao)

+ (id)buttonWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName alwaysRenderingAsTemplate:(BOOL)alwaysRenderingAsTemplate title:(NSString *)title target:(id)target action:(SEL)action;

- (void)makeVerticalWithPadding:(CGFloat)padding;

@end


@interface UITextField (MamHao)

- (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacters;

- (NSString *)nonNilText;

- (NSInteger)textLengh;

@end


@interface UIViewController (MamHao)

- (void)popWithAnimation;
- (void)dismissViewControllerWithAnimation;

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;
- (void)hideHud;
- (void)showHint:(NSString *)hint;
// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

@end


@interface UINavigationController (MamHao)

- (void)popToViewControllerOfClass:(Class)aClass;

@end


@interface UITextView (MamHao)

- (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacters;
- (CGFloat)textHeight;

@end


@interface UIBarButtonItem (MamHao)

+ (id)itemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title target:(id)target action:(SEL)action;
+ (id)itemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

@end


@interface UITableView (MamHao)

- (NSIndexPath *)lastIndexPath;
- (void)scrollToLastRowAnimated:(BOOL)animated;
- (BOOL)lastCellVisible;
- (void)setTableViewSeparatorInsets:(UIEdgeInsets)insets;

@end


@interface UITableViewCell (MamHao)

- (void)setCellSeparatorInsets:(UIEdgeInsets)insets;

@end


@interface UIApplication (MamHao)

- (void)clearNotificationMark;
+ (void)tryToCallPhoneNumber:(NSString *)phoneNumber;
@end


typedef NS_ENUM(NSInteger, LESScreenMode) {
    LESScreenModeIPhone4SOrEarlier,
    LESScreenModeIPhone5Series,
    LESScreenModeIPhone6,
    LESScreenModeIPhone6Plus,
    
    LESScreenModeIPadPortrait,
    LESScreenModeIPadLandscape,
    
    LESScreenModeUnknown,
};


@interface UIScreen (MamHao)

+ (LESScreenMode)currentScreenMode;

@end


@interface NSDate (MamHao)

//若format为nil ,默认为 yyyy.MM.dd HH: mm: ss 格式
- (NSString *)stringRepresentationWithDateFormat:(NSString *)format;
+ (NSDate *)dateWithTimestamp:(NSTimeInterval)timestamp;
+ (NSDate *)dateWithString:(NSString *)timeStr withFormat:(NSString *)format;
- (BOOL)earlierThan:(NSDate *)otherDate;
- (BOOL)laterThan:(NSDate *)otherDate;

//获取日
- (NSUInteger) getDay;

//获取月
- (NSUInteger) getMonth;

//获取年
- (NSUInteger) getYear;

//获取小时
- (NSUInteger ) getHour;

//获取分钟
- (NSUInteger) getMinute;


@end


@interface NSData (MamHao)

- (NSString *)md5String;

@end


@interface NSFileManager (MamHao)

+ (void)setExcludedFromBackup:(BOOL)excluded forFileAtpath:(NSString *)path;
- (unsigned long long int)documentsFolderSize:(NSString *)documentPath;
- (void)removeFileAtPath:(NSString *)path condition:(BOOL (^)(NSString *))block;
+ (BOOL)removeItemIfExistsAtPath:(NSString *)path error:(NSError **)error;

@end

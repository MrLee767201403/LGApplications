//
//  NSString+Extension.m
//  FrameWork
//
//  Created by 李刚 on 2017/5/10.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

/**
 *  32位MD5加密
 */
-(NSString *)md5{

    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];

    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);

    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }

    return [result copy];
}




/**
 *  SHA1加密
 */
-(NSString *)sha1{

    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);

    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }

    return [result copy];
}

- (NSURL *)url{
    return [NSURL URLWithString:self];
}

/**  是不是空字符串*/
- (BOOL)isEmptyString{
    if (self && [self isKindOfClass:[NSString class] ] && [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0)
    {
        return NO;
    }
    return YES;
}

/**  去除字符串两端空格 和换行符*/
- (NSString *)trimming{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**  去除字符串两端空格*/
- (NSString *)trimmingSpace{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//得到中英文混合字符串长度 方法2
- (NSInteger)getByteLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [self dataUsingEncoding:enc];
    return [data length];
}


+ (NSString *)calculateTimeWithTimeFormatter:(long long)timeSecond {
    NSString * theLastTime = nil;
    if (timeSecond < 60) {
        theLastTime = [NSString stringWithFormat:@"00:%.2lld", timeSecond];
    }else if(timeSecond >= 60 && timeSecond < 3600){
        theLastTime = [NSString stringWithFormat:@"%.2lld:%.2lld", timeSecond/60, timeSecond%60];
    }else if(timeSecond >= 3600){
        theLastTime = [NSString stringWithFormat:@"%.2lld:%.2lld:%.2lld", timeSecond/3600, timeSecond%3600/60, timeSecond%60];
    }
    return theLastTime;
}


- (NSString *)urlEncode{
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]{}\""] invertedSet];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
}

- (NSString *)urlDecode{
    return [self stringByRemovingPercentEncoding];
}

- (NSMutableAttributedString *)stringWithLineSpacing:(CGFloat)lineSpacing{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing; // 调整行间距
    NSRange range = NSMakeRange(0, [self length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}
@end

//
//  NSString+Extension.h
//  FrameWork
//
//  Created by 李刚 on 2017/5/10.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
/**
 *  32位MD5加密
 */
@property (nonatomic,copy,readonly) NSString *md5;


/**
 *  SHA1加密
 */
@property (nonatomic,copy,readonly) NSString *sha1;

/**  对应的URL*/
@property (nonatomic,copy,readonly) NSURL *url;

/**  是不是空字符串*/
- (BOOL)isEmptyString;


/**  去除字符串两端空格 和换行符*/
- (NSString *)trimming;

/**  去除字符串两端空格*/
- (NSString *)trimmingSpace;
@end

//
//  UIView+Extension.h
//  FrameWork
//
//  Created by 李刚 on 17/5/9.
//  Copyright (c) 2017年 李刚. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)
- (NSString*)stringForKey:(NSString*)key;
- (int)intForKey:(NSString*)key;
- (float)floatForKey:(NSString*)key;
- (double)doubleForKey:(NSString*)key;
- (NSDictionary *)removeNull;
@end


@interface NSArray (Extension)

@end



@interface NSSet (Extension)

@end


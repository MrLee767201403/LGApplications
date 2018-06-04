//
//  KeyChainStore.h
//  Trainee
//
//  Created by 李刚 on 2018/6/4.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject
+ (void)save:(NSString*)service data:(id)data; // 保存
+ (id)load:(NSString*)service;                 // 获取
+ (void)deleteKeyData:(NSString*)service;      // 删除
@end

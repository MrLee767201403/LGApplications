//
//  LGHttpResult.h
//  FollowerTracker
//
//  Created by 李刚 on 2019/5/7.
//  Copyright © 2019 ligang. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kLGHttpResultCodeSeccess  0
NS_ASSUME_NONNULL_BEGIN

@interface LGHttpResult : NSObject
@property (nonatomic, strong) id response;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger statusCode;

- (instancetype)initWithResponse:(id)response;

- (instancetype)initWithError:(NSError *)error;
@end



@interface LGPostData : NSObject
@property(nonatomic, strong) NSData *data;         // 数据
@property(nonatomic, strong) NSString *fileName;     // pic.jpeg...
@property(nonatomic, strong) NSString *contentType;  // image/jpeg...
@end


@interface LGPostFile : NSObject
@property(nonatomic, strong) NSString *filePath;         //  路经
@property(nonatomic, strong) NSString *fileName;     // pic.jpeg...
@property(nonatomic, strong) NSString *contentType;  // image/jpeg...
@end

NS_ASSUME_NONNULL_END

//
//  LGHttpRequest.h
//
//  Created by 李刚 on 2019/5/7.
//  Copyright © 2019 ligang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGHttpResult.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SuccessHandle)(LGHttpResult *result);
typedef void(^ErrorHandle)(LGHttpResult *result);

static NSString * _Nonnull const  LGHttpMethedPost         = @"POST";
static NSString * _Nonnull const  LGHttpMethedGet          = @"GET";

@class AFHTTPSessionManager;
@interface LGHttpRequest : NSObject
@property (nonatomic, assign) BOOL xauth; // 是否需要签名(默认 NO)
@property (nonatomic, assign) BOOL cache; // 是否需要缓存(默认 NO)
@property (nonatomic, assign) BOOL hideToastOnSuccess; // 成功后是否直接隐藏toast(默认 YES)

@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSString *method; // 默认GET
@property (nonatomic, strong) NSString *url;

/**  默认GET请求 仅支持简单的请求 不支持上传*/
- (void)startRequsetWithSuccess:(SuccessHandle)success failure:(nullable ErrorHandle)failure;

/**  GET请求*/
- (void)getWithURL:(NSString *)url success:(SuccessHandle)success failure:(nullable ErrorHandle)failure;

/**  POST请求*/
- (void)postWithURL:(NSString *)url success:(SuccessHandle)success failure:(nullable ErrorHandle)failure;

/**  上传 Data*/
- (void)postWithURL:(NSString *)url postData:(NSDictionary *)postData success:(SuccessHandle)success failure:(nullable ErrorHandle)failure;

/**  上传文件*/
- (void)postWithURL:(NSString *)url postFile:(NSDictionary *)postFile success:(SuccessHandle)success failure:(nullable ErrorHandle)failure;

/**  获取缓存*/
- (void)getCacheDataSuccess:(SuccessHandle)success failure:(nullable ErrorHandle)failure;
@end

NS_ASSUME_NONNULL_END

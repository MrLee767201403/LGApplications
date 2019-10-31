//
//  LGHttpRequest.m
//  FollowerTracker
//
//  Created by 李刚 on 2019/5/7.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "LGHttpRequest.h"

@implementation LGHttpRequest

/*
- (instancetype)init
{
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.operationQueue.maxConcurrentOperationCount = 4;
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _params = [self commonParameters];
        _xauth = NO;
        _cache = NO;
        _method = LGHttpMethedGet;
    }
    return self;
}

- (void)startRequsetWithSuccess:(SuccessHandle)success failure:(ErrorHandle)failure{

    if ((![self.url isKindOfClass:NSString.class] && ![self.url isKindOfClass:NSURL.class]) || self.url.length == 0){
        NSError *error = [NSError errorWithDomain:@"无效的URL" code:-200 userInfo:@{NSLocalizedDescriptionKey:@"Error: 无效的网络请求"}];
        LGHttpResult *result = [[LGHttpResult alloc] initWithError:error];
        if(failure) failure(result);
        return;
    }
    if ([self.method isEqualToString:@"GET"]) {
        [self getWithURL:self.url success:success failure:failure];
    }else{
        [self postWithURL:self.url success:success failure:failure];
    }
}

#pragma mark   -  GET
- (void)getWithURL:(NSString *)url success:(SuccessHandle)success failure:(ErrorHandle)failure{
    // 签名
    if (self.xauth) {
        NSDictionary *signParams = [self xauth:url method:@"GET" params:self.params];
        [self.params setValuesForKeysWithDictionary:signParams];
    }

    LGLog(@"LGHttpRequest:\nURL:\n%@\nparams\n%@",url,self.params);
    NSURLSessionDataTask *dataTask = [self.sessionManager GET:url parameters:self.params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LGHttpResult *result = [[LGHttpResult alloc] initWithResponse:responseObject];
        if (self.cache) [self cacheRequestResult:responseObject];

        // 只有请求成功 才走成功回调
        if (result.code == kLGHttpResultCodeSeccess) {
            [LGToastView hideToast];
            if (success) success(result);
        }else{
            [self didReceiveErrorResult:result failure:failure];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self didReceiveError:error failure: failure];
    }];

    [dataTask resume];

}

#pragma mark   -  POST
- (void)postWithURL:(NSString *)url success:(SuccessHandle)success failure:(ErrorHandle)failure{

    if (self.xauth) {
        NSDictionary *signParams = [self xauth:url method:@"POST" params:self.params];
        [self.params setValuesForKeysWithDictionary:signParams];
    }

    LGLog(@"LGHttpRequest:\nURL:\n%@\nparams\n%@",url,self.params);

    NSURLSessionDataTask *dataTask = [self.sessionManager POST:url parameters:self.params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LGHttpResult *result = [[LGHttpResult alloc] initWithResponse:responseObject];
        if (self.cache) [self cacheRequestResult:responseObject];

        if (result.code == kLGHttpResultCodeSeccess) {
            [LGToastView hideToast];
            if (success) success(result);
        }else{
            [self didReceiveErrorResult:result failure:failure];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self didReceiveError:error failure: failure];
    }];

    [dataTask resume];
}

#pragma mark   -  FormData
- (void)postWithURL:(NSString *)url postData:(NSDictionary *)postData success:(SuccessHandle)success failure:(ErrorHandle)failure{
    [self postWithURL:url postData:postData postFile:nil success:success failure:failure];
}

- (void)postWithURL:(NSString *)url postFile:(NSDictionary *)postFile success:(SuccessHandle)success failure:(ErrorHandle)failure{
    [self postWithURL:url postData:nil postFile:postFile success:success failure:failure];
}

- (void)postWithURL:(NSString *)url postData:(NSDictionary *)postData postFile:(NSDictionary *)postFile success:(SuccessHandle)success failure:(ErrorHandle)failure{

    if (self.xauth) {
        NSDictionary *signParams = [self xauth:url method:@"POST" params:self.params];
        [self.params setValuesForKeysWithDictionary:signParams];
    }

    LGLog(@"LGHttpRequest:\nURL:\n%@\nparams\n%@",url,self.params);
    NSURLSessionDataTask *dataTask = [self.sessionManager POST:url parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        if(postData.count){
            for (NSString *key in postData.allKeys) {
                LGPostData *dataParam = [postData objectForKey:key];
                [formData appendPartWithFileData:dataParam.data name:key fileName:dataParam.fileName mimeType:dataParam.contentType];
            }
        }
        if(postFile.count){
            for (NSString *key in postFile.allKeys) {
                LGPostFile *fileParam = [postData objectForKey:key];
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:fileParam.filePath] name:key fileName:fileParam.fileName mimeType:fileParam.contentType error:nil];
            }
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LGHttpResult *result = [[LGHttpResult alloc] initWithResponse:responseObject];
        if (result.code == kLGHttpResultCodeSeccess) {
            [LGToastView hideToast];
            if (success) success(result);
        }else{
            [self didReceiveErrorResult:result failure:failure];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self didReceiveError:error failure:failure];
    }];

    [dataTask resume];
}

#pragma mark   -  错误统一处理
- (void)didReceiveError:(NSError *)error failure:(ErrorHandle)failure{

    LGHttpResult *result = [[LGHttpResult alloc] initWithError:error];
    NSData *data = [error.userInfo valueForKey:@"com.alamofire.serialization.response.error.data"];

    // 非restful
    if (!data || ![NSJSONSerialization isValidJSONObject:data]){
        [NSUtil performBlockOnMainThread:^{
            [LGToastView hideToast];
            [LGToastView showToastWithError:kToastNetworkError];
        }];
        if (failure) failure(result);
    }
    // restful
    else{
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        result.code = [[dict stringForKey:@"status"] integerValue];
        result.message = [dict stringForKey:@"message"];
        [self didReceiveErrorResult:result failure:failure];
    }
}

- (void)didReceiveErrorResult:(LGHttpResult *)result failure:(ErrorHandle)failure{

    [NSUtil performBlockOnMainThread:^{
        [LGToastView hideToast];

        // 重新登录
        if (result.code == 401) {
            AlertView *alert = [[AlertView alloc] initWithContent:@"您的登录信息已失效，请重新登录"];
            alert.singleButton = YES;
            alert.yesHandle = ^{
                [[UserManager shareManager] logOut];
            };
            [alert show];
        }
        else{
            if (result.message.length) {
                [LGToastView showToastWithError:result.message];
            }
            else{
                [LGToastView showToastWithError:kToastNetworkError];
            }
        }
        if (failure) failure(result);
    }];
}

#pragma mark   -  公共参数
- (NSMutableDictionary *)commonParameters{

    NSMutableDictionary *allParams = @{}.mutableCopy;

    [allParams setValue:@"iOS" forKey:@"client"];
    [allParams setValue:[NSUtil getUUID] forKey:@"uuid"];
    [allParams setValue:[NSUtil getAppVersion] forKey:@"client_version"];      // app版本
    [allParams setValue:[UserManager shareManager].user.userId forKey:@"userId"];
    [allParams setValue:[UserManager shareManager].user.token forKey:@"token"];
    [allParams setValue:[UserManager shareManager].user.companyId forKey:@"companyId"];

    return allParams;
}

- (NSDictionary*)xauth:(NSString*)url method:(NSString*)method params:(NSDictionary*)params {
    return [HAXAuthSign generateURLParams:method.uppercaseString requestURL:url params:params.mutableCopy consumerKey:CONSUMER_KEY consumerKeySecret:CONSUMER_SECRET accessToken:@"" tokenSecret:@""];
}


#pragma mark   -  缓存
- (void)getCacheDataSuccess:(SuccessHandle)success failure:(ErrorHandle)failure{
    NSError *error = nil;
    NSString *path = [NSUtil getCacheFilePath:[self getCacheUrl]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) {
        NSError *error = [NSError errorWithDomain:@"Data is nil" code:-200 userInfo:@{NSLocalizedDescriptionKey:@"Error: 无效的URL / 未获取到缓存数据"}];
        LGHttpResult *result = [[LGHttpResult alloc] initWithError:error];
        if(failure) failure(result);
        return;
    }
    @try {
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        LGHttpResult *result = [[LGHttpResult alloc] initWithResponse:responseObject];
        if(success) success(result);
    } @catch (NSException *exception) {
        LGLog(@"获取缓存失败: \n%@",exception);
        LGHttpResult *result = [[LGHttpResult alloc] initWithError:error];
        if(failure) failure(result);
    }
}
*/
 /**  只保存请求成功的*/
- (void)cacheRequestResult:(id)responseObject {

    NSError *error = nil;
    NSString *path = [NSUtil getCacheFilePath:[self getCacheUrl]];

    @try {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
        [jsonData writeToFile:path atomically:YES];
    } @catch (NSException *exception) {
        LGLog(@"保存失败: \n%@",exception);
    }
}



- (NSString*)getCacheUrl
{
    if (!self.cache) {
        return nil;
    }

    NSMutableString *query = [NSMutableString string];
    NSString* cacheUrl = self.url;
    if (self.params) {
        for (NSString *key in self.params.allKeys) {

            id value = [self.params valueForKey:key];
            if ([value isKindOfClass:[NSString class]]) {
                NSString* str = value;
                [query appendFormat:@"%@=%@&", key.urlEncode, str.urlDecode];
            }
            else if([value respondsToSelector:@selector(stringValue)]){
                NSString* str = [value stringValue];
                [query appendFormat:@"%@=%@&", key.urlEncode, str.urlDecode];
            }
        }
        if ([query length] > 0) {
            cacheUrl = [NSString stringWithFormat:@"%@?%@", self.url, [query substringToIndex:query.length - 1]];
        }
    }
    return cacheUrl.md5;
}

@end

//
//  LGHttpResult.m
//  FollowerTracker
//
//  Created by 李刚 on 2019/5/7.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "LGHttpResult.h"

@implementation LGHttpResult

- (instancetype)initWithResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _statusCode = 200;
        _response = response;
        _message = [response stringForKey:@"info"];
        _code = [[response stringForKey:@"code"] integerValue];
        _data = [response valueForKey:@"data"];

        LGLog(@"LGHttpResult:\n%@",response);
    }
    return self;
}


- (instancetype)initWithError:(NSError *)error
{
    self = [super init];
    if (self) {
        _statusCode = error.code;
        _message = error.localizedDescription;
        LGLog(@"LGHttpResult:\n%@",error);
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"LGHttpResult:\n%@", self.response];
}
@end



@implementation LGPostData

- (NSString *)contentType{
    if (_contentType == nil) {
        _contentType = @"image/jpeg";
    }
    return _contentType;
}
@end;


@implementation LGPostFile

@end;

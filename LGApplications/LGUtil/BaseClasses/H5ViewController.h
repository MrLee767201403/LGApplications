//
//  H5ViewController.h
//  HongBao
//
//  Created by 李刚 on 2019/12/26.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface H5ViewController : BaseViewController
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) ActionBlock backBlock;
- (instancetype)initWithUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END

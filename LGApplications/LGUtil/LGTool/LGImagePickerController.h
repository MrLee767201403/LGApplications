//
//  LGImagePickerController.h
//  HumanResource
//
//  Created by 李刚 on 2019/10/19.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "BaseViewController.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^ImageBlock)(UIImage *image);

@interface LGImagePickerController : BaseViewController
@property (nonatomic, copy) ImageBlock complete;
@end


@interface LGImageCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *originalImage;

@end
NS_ASSUME_NONNULL_END

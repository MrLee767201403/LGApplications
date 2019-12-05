//
//  LGImageManager.m
//  H3
//
//  Created by 李刚 on 2018/6/8.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import "LGImageManager.h"

@interface LGImageManager ()

@end



@implementation LGImageManager
static LGImageManager *manager;
static dispatch_once_t onceToken;

+ (instancetype)manager {
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)deallocManager {
    onceToken = 0;
    manager = nil;
}

#pragma mark - 获取权限
+ (PHAuthorizationStatus)authorizationStatus {
    return [PHPhotoLibrary authorizationStatus];
}

+ (AVAuthorizationStatus)cameraAuthorizationStatus {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    return [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
}

#pragma mark - 请求权限
+ (void)requestAuthorizationWithType:(UIImagePickerControllerSourceType)type allowed:(void (^)(BOOL allowed))result
{
    NSInteger currentStatus = 0;
    NSString *alert = nil;
    if (type == UIImagePickerControllerSourceTypeCamera) {
        currentStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        alert = @"In the iPhone's Settings - privacy - camera option, allow access to your camera";
    }
    else{
        currentStatus = [PHPhotoLibrary authorizationStatus];
        alert = @"In the iPhone's Settings - privacy - photos option, allow access to your photos";
    }
    switch (currentStatus) {
        case PHAuthorizationStatusAuthorized://已授权，可使用
        {
            result(YES);
            break;
        }
        case PHAuthorizationStatusNotDetermined://未进行授权选择
        {
            //则再次请求授权
            if (type == UIImagePickerControllerSourceTypeCamera) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    result(granted);
                    if (granted == NO) {[self showAlert:alert];}
                }];
            }
            else{
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {
                        result(YES);
                    }
                    else{
                        [self showAlert:alert];
                        result(NO);
                    }
                }];
            }
            break;
        }
        case PHAuthorizationStatusRestricted:
        {
            [self showAlert:alert];
            result(NO);
            break;
        }
        default:
        {
            result(NO);
            break;
        }
    }
}

+ (void)showAlert:(NSString *)alert{
    //用户拒绝授权
    dispatch_async(dispatch_get_main_queue(), ^{

        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Alert" message:alert preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [kApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:OK];
        [alertVC addAction:cancel];
        [[NSUtil currentController] presentViewController:alertVC animated:YES completion:nil];
    });
}


#pragma mark - 相机胶卷内所有图片
+ (NSArray *)getAllAssetInCameraRollWithAscending:(BOOL)ascending{
    __block NSArray *asset = nil;
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    if (!ascending) option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *  _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        //获取相册内asset result
        PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if (collection.assetCollectionSubtype == 209) {
            asset = [self getPhotoInResult:result allowSelectVideo:NO allowSelectImage:YES allowSelectGif:NO allowSelectLivePhoto:NO limitCount:NSIntegerMax];
        }
    }];
    return asset;
}

#pragma mark - 根据条件获取所有图片
/**  根据条件获取所有图片*/
+ (NSArray *)getAllAssetInPhotoAlbumWithAscending:(BOOL)ascending allowSelectVideo:(BOOL)allowSelectVideo allowSelectImage:(BOOL)allowSelectImage allowSelectGif:(BOOL)allowSelectGif allowSelectLivePhoto:(BOOL)allowSelectLivePhoto limitCount:(NSInteger)limit
{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsWithOptions:option];
    return [self getPhotoInResult:result allowSelectVideo:allowSelectVideo allowSelectImage:allowSelectImage allowSelectGif:allowSelectGif allowSelectLivePhoto:allowSelectLivePhoto limitCount:limit];
}

#pragma mark - 根据条件获取所有图片
/**  根据条件获取所有图片*/
+ (NSArray*)getPhotoInResult:(PHFetchResult<PHAsset *> *)result allowSelectVideo:(BOOL)allowSelectVideo allowSelectImage:(BOOL)allowSelectImage allowSelectGif:(BOOL)allowSelectGif allowSelectLivePhoto:(BOOL)allowSelectLivePhoto limitCount:(NSInteger)limit
{
    NSMutableArray *arrModel = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block NSInteger count = 1;
        switch (obj.mediaType) {
            case PHAssetMediaTypeAudio:
                return;
            case PHAssetMediaTypeVideo:
                if (allowSelectVideo == NO) return;
            case PHAssetMediaTypeImage:
                if ([[obj valueForKey:@"filename"] hasSuffix:@"GIF"] && allowSelectGif==NO)return;
                if ((obj.mediaSubtypes == PHAssetMediaSubtypePhotoLive || obj.mediaSubtypes == 10) &&allowSelectLivePhoto==NO) return;
                break;
            case PHAssetMediaTypeUnknown:
                return;
        }
        if (count == limit) {
            *stop = YES;
        }
        [arrModel addObject:obj];
        count++;
    }];
    return arrModel;
}


#pragma mark - 获取asset对应的原图
/**  获取某张图片的原图*/
+ (void)requestOriginalImageForAsset:(PHAsset *)asset completion:(void (^)(UIImage *image, NSDictionary *info))completion
{
    [self requestImageForAsset:asset size:PHImageManagerMaximumSize resizeMode:PHImageRequestOptionsResizeModeFast completion:completion];
}

#pragma mark - 获取asset对应的默认屏幕宽高的图片
/**  获取默认屏幕宽高的图片*/
+ (void)requestDefaultImageForAsset:(PHAsset *)asset completion:(void (^)(UIImage *image, NSDictionary *info))completion
{
    CGFloat scale = 2;
    CGFloat width = MIN(kScreenWidth, kViewHeight);
    CGSize size = CGSizeMake(width*scale, width*scale*asset.pixelHeight/asset.pixelWidth);
    [self requestImageForAsset:asset size:size completion:completion];
}

#pragma mark - 获取asset对应的图片
+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset size:(CGSize)size completion:(void (^)(UIImage *image, NSDictionary *info))completion{
    return [self requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:completion];
}

+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image, NSDictionary *info))completion
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */

    option.resizeMode = resizeMode;//控制照片尺寸
    //    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    option.networkAccessAllowed = CGSizeEqualToSize(size, PHImageManagerMaximumSize);

    if (option.networkAccessAllowed) {
        [LGToastView showLoading:@"正在加载"];
    }
    /*
     info字典提供请求状态信息:
     PHImageResultIsInCloudKey：图像是否必须从iCloud请求
     PHImageResultIsDegradedKey：当前UIImage是否是低质量的，这个可以实现给用户先显示一个预览图
     PHImageResultRequestIDKey和PHImageCancelledKey：请求ID以及请求是否已经被取消
     PHImageErrorKey：如果没有图像，字典内的错误信息
     */

    return [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        //BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
        //不要该判断，即如果该图片在iCloud上时候，会先显示一张模糊的预览图，待加载完毕后会显示高清图
        // && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]
        if (image && completion) {
            completion(image, info);
            [LGToastView hideToast];
        }
    }];
}



#pragma mark - 获取asset对应的LivePhoto
+ (void)requestLivePhotoForAsset:(PHAsset *)asset completion:(void (^)(PHLivePhoto *photo, NSDictionary *info))completion
{
    PHLivePhotoRequestOptions *option = [[PHLivePhotoRequestOptions alloc] init];
    option.version = PHImageRequestOptionsVersionCurrent;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    option.networkAccessAllowed = YES;

    [[PHCachingImageManager defaultManager] requestLivePhotoForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        if (completion) completion(livePhoto, info);
    }];
}

#pragma mark - 获取asset对应的视频
+ (void)requestVideoForAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem *item, NSDictionary *info))completion
{
    [[PHCachingImageManager defaultManager] requestPlayerItemForVideo:asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        if (completion) completion(playerItem, info);
    }];
}

/**  保存图片*/
- (void)savePhotoWithImage:(UIImage *)image completion:(void (^)(NSError *error))completion {
    [self savePhotoWithImage:image location:nil completion:completion];
}

- (void)savePhotoWithImage:(UIImage *)image location:(CLLocation *)location completion:(void (^)(NSError *error))completion {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        if (@available(iOS 9.0, *)) {
            NSData *data = UIImageJPEGRepresentation(image, 0.9);
            PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
            options.shouldMoveFile = YES;
            PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
            [request addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
            if (location) {
                request.location = location;
            }
            request.creationDate = [NSDate date];
        } else {
            PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            if (location) {
                request.location = location;
            }
            request.creationDate = [NSDate date];
        }
    } completionHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success && completion) {
                completion(nil);
            } else if (error) {
                NSLog(@"保存照片出错:%@",error.localizedDescription);
                if (completion) {
                    completion(error);
                }
            }
        });
    }];
}

/**  裁剪圆形图片*/
+ (UIImage *)roundClipImage:(UIImage *)image{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);

    [image drawInRect:rect];
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return circleImage;
}



+ (void)uploadImage:(UIImage *)image complete:(StringBlock)complete failed:(StringBlock)error{
    
    NSData *imageData =  UIImageJPEGRepresentation([NSUtil imageWithOriginalImage:image], 0.6);
    LGPostData *postData = [[LGPostData alloc] init];
    postData.data = imageData;
    postData.contentType = @"image/jpeg";
    postData.fileName = [NSString stringWithFormat:@"image_%lf",NSDate.date.timeIntervalSince1970];
    LGHttpRequest *request = [[LGHttpRequest alloc] init];

    [request postWithURL:@"" postData:@{@"file":postData} success:^(LGHttpResult * _Nonnull result) {
        NSString *imageURL = [result.data valueForKey:@"img"];
        complete(imageURL);
        NSLog(@"%@",imageURL);
    } failure:^(LGHttpResult * _Nonnull result) {
        error(result.message);
    }];
}

@end

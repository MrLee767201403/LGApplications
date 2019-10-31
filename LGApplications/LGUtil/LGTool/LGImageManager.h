//
//  LGImageManager.h
//  H3
//
//  Created by 李刚 on 2018/6/8.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^ImageResult)(UIImage *image, NSDictionary *info);

@interface LGImageManager : NSObject
+ (instancetype)manager;
+ (void)deallocManager;
+ (PHAuthorizationStatus)authorizationStatus;  // 相册权限
+ (AVAuthorizationStatus)cameraAuthorizationStatus;  // 相机权限
+ (void)requestAuthorizationWithType:(UIImagePickerControllerSourceType)type allowed:(void (^)(BOOL allowed))result;



/*
 取出的都是 PHAsset 可以直接将 PHAsset 传到要显示的地方
 然后通过 requestImageForAsset: 获取单个图片
 如果直接获取所有图片,会很慢 而且容易造成内存激增
*/

#pragma mark - 相机胶卷内所有图片
+ (NSArray *)getAllAssetInCameraRollWithAscending:(BOOL)ascending;

#pragma mark - 根据条件获取所有图片
/**  根据条件获取所有图片资源 PHAsset对象*/
+ (NSArray *)getAllAssetInPhotoAlbumWithAscending:(BOOL)ascending allowSelectVideo:(BOOL)allowSelectVideo allowSelectImage:(BOOL)allowSelectImage allowSelectGif:(BOOL)allowSelectGif allowSelectLivePhoto:(BOOL)allowSelectLivePhoto limitCount:(NSInteger)limit;
#pragma mark - 获取asset对应的原图
/**  获取某张图片的原图*/
+ (void)requestOriginalImageForAsset:(PHAsset *)asset completion:(ImageResult)completion;

#pragma mark - 获取asset对应的默认屏幕宽高的图片
/**  获取默认屏幕宽高的图片*/
+ (void)requestDefaultImageForAsset:(PHAsset *)asset completion:(ImageResult)completion;

#pragma mark - 获取asset对应的图片
+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset size:(CGSize)size completion:(ImageResult)completion;

#pragma mark - 获取asset对应的LivePhoto
+ (void)requestLivePhotoForAsset:(PHAsset *)asset completion:(void (^)(PHLivePhoto *photo, NSDictionary *info))completion;

#pragma mark - 获取asset对应的视频
+ (void)requestVideoForAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem *item, NSDictionary *info))completion;



#pragma mark - 保存照片
/**  Save photo 保存照片*/
- (void)savePhotoWithImage:(UIImage *)image completion:(void (^)(NSError *error))completion;
- (void)savePhotoWithImage:(UIImage *)image location:(CLLocation *)location completion:(void (^)(NSError *error))completion;

/**  裁剪圆形图片*/
+ (UIImage *)roundClipImage:(UIImage *)image;

+ (void)uploadImage:(UIImage *)image complete:(StringBlock)complete failed:(StringBlock)error;
@end

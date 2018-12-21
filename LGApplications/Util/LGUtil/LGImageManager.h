//
//  LGImageManager.h
//  H3
//
//  Created by 李刚 on 2018/6/8.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface LGImageManager : NSObject
+ (instancetype)manager;
+ (void)deallocManager;
+ (PHAuthorizationStatus)authorizationStatus;

+ (void)requestAuthorizationWithType:(UIImagePickerControllerSourceType)type allowed:(void (^)(BOOL allowed))result;

/**  必须实现UIImagePickerControllerDelegate里的代理方法  && UIViewController的子类*/
+ (void)selectImageWithType:(UIImagePickerControllerSourceType)type allowEdit:(BOOL)allow  pickerDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)delegate;
@end

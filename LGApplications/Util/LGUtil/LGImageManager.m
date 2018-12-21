//
//  LGImageManager.m
//  H3
//
//  Created by 李刚 on 2018/6/8.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import "LGImageManager.h"

 #define kHttpRequestHeadContentTypeValueMultipart @"multipart/form-data; boundary=h3uploadimage"
 #define kHttpRequestHeadContentTypeKey @"Content-Type"
 #define kHttpRequestHeadBoundaryValue @"h3uploadimage"
 #define kHttpRequestContentDisposition @"Content-Disposition: form-data"

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


+ (PHAuthorizationStatus)authorizationStatus {
    return [PHPhotoLibrary authorizationStatus];
}


+ (void)requestAuthorizationWithType:(UIImagePickerControllerSourceType)type allowed:(void (^)(BOOL allowed))result
{
    NSString *name = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"];
    NSString *alert = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许“%@”访问你的相机",name];
    PHAuthorizationStatus currentStatus = [PHPhotoLibrary authorizationStatus];
    switch (currentStatus) {
        case PHAuthorizationStatusAuthorized://已授权，可使用
        {
            result(YES);
            break;
        }
        case PHAuthorizationStatusNotDetermined://未进行授权选择
        {
            //则再次请求授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    result(YES);
                }
                else{
                    //用户拒绝授权
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:alert preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                        [alertVC addAction:cancel];
                        [[NSUtil currentController] presentViewController:alertVC animated:YES completion:nil];
                    });
                    result(NO);
                }
            }];
            
            break;
        }
        default://用户拒绝授权/未授权
        {
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:alert preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:cancel];
            [[NSUtil currentController] presentViewController:alertVC animated:YES completion:nil];
            result(NO);
            break;
        }
    }
}

+ (void)selectImageWithType:(UIImagePickerControllerSourceType)type allowEdit:(BOOL)allow pickerDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>) delegate {

    [LGImageManager requestAuthorizationWithType:type allowed:^(BOOL allowed) {
        if (allowed == YES && [UIImagePickerController isSourceTypeAvailable:type]) {

            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.view.backgroundColor = [UIColor whiteColor];
            controller.sourceType = type;
            controller.delegate = delegate;
            controller.allowsEditing = allow;

            if ([delegate isKindOfClass:UIViewController.class]) {
                UIViewController *sender = (UIViewController *)delegate;
                [sender.navigationController presentViewController:controller animated:YES completion:nil];
            }else{
                NSLog(@"Error: delegate 必须是UIViewController的子类");
            }
        }
    }];
}

@end

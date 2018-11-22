//
//  LocationManager.m
//  Trainee
//
//  Created by 李刚 on 2018/6/27.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import "LocationManager.h"
static LocationManager *_shareLocationManager;

@implementation LocationManager

{
    LocationBlock _block;
    LocationBlock _geocodeBlock;
    NSString *_address;
    CLLocation *_location;
    CLLocationManager *_manager;

}

+ (LocationManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareLocationManager = [[self alloc] init];
    });
    return _shareLocationManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _location = nil;
        
        if ([NSThread currentThread] == [NSThread mainThread]) {
            [self initManager];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self initManager];
            });
        }
    }
    
    return self;
}


- (void)initManager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.distanceFilter = 500.0f;
        _manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _manager.delegate = self;
    }
}


- (void)getLocation:(LocationBlock)handle{
    _block = handle;
    
    if (_location.coordinate.latitude && _address.length) {
        handle(_location,_address);
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_manager requestWhenInUseAuthorization];
    }
    [_manager startUpdatingLocation];
}

- (void)updateLocation:(LocationBlock)handle{
    _block = handle;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_manager requestWhenInUseAuthorization];
    }
    [_manager startUpdatingLocation];
}

#pragma mark <CLLocationManagerDelegate>
// 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // 如果关闭了权限 提示设置
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self locationManager:manager didChangeAuthorizationStatus:kCLAuthorizationStatusDenied];
    }
    else{
        [LGToastView showToastWithError:@"获取位置信息失败，请稍后再试"];
    }
    [_manager stopUpdatingLocation];
}

// 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * location = locations.lastObject;
    if (location.coordinate.latitude) {
        // 结束定位
        _location = location;
        [self getDetailAddressWithLocation:location];
        [_manager performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:0.1f];
    }
}

// 定位权限状态改变
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [manager startUpdatingLocation];
    }
    else if (status == kCLAuthorizationStatusDenied){
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        NSDictionary *info = [NSBundle mainBundle].infoDictionary;
        NSString *message = [NSString stringWithFormat:@"您已关闭定位服务,这将直接影响到某些功能的使用,请您前往\"设置-隐私-定位服务-%@\"打开定位服务",info[@"CFBundleDisplayName"]];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *gotoSetting = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [kApplication openURL:url];
        }];
        [alertVC addAction:cancel];
        [alertVC addAction:gotoSetting];
//        [[NSUtil currentViewController] presentViewController:alertVC animated:YES completion:nil];
    }
    else if (status == kCLAuthorizationStatusRestricted){
        [LGToastView showToastWithError:@"无法获取您的位置信息, 请检查网络"];
    }
}

- (void )reverseGeocodeLocation:(CLLocation *)location complete:(LocationBlock)handle{
    _geocodeBlock = handle;
    [self getDetailAddressWithLocation:location];
}



- (void )getDetailAddressWithLocation:(CLLocation *)location{
    
    // 反地理编码
    //    CLLocation * loc1 = [[CLLocation alloc] initWithLatitude:39.8 longitude:116.7];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         
         if (placemarks.count)
         {
             CLPlacemark *placemark = placemarks.firstObject;
             
             NSString *address  = [placemark.addressDictionary[@"FormattedAddressLines"] firstObject];
             
             // 如果是中国 去掉国家信息
             if ([address hasPrefix:@"中国"]) {
                 address = [address substringFromIndex:2];
             }
             
             // 去掉楼层信息
             NSString *lastChar = [address substringFromIndex:address.length-1];
             
             if ([lastChar isEqualToString:@"层"]) {
                 // 层
                 address = [address substringToIndex:address.length-1];
                 lastChar = [address substringFromIndex:address.length-1];
                 NSString *regex = @"\\d$|-";
                 NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                 
                 // 如果最后一个字符是数字
                 while ((![lastChar isEqualToString:@"楼"]) && address.length > 1 && [regExPredicate evaluateWithObject:lastChar])
                 {
                     address = [address substringToIndex:address.length-1];
                     lastChar = [address substringFromIndex:address.length-1];
                 }
             }
             address = [address trimming].length?address : @"获取位置信息失败，请稍后再试";
             _address = [address copy];
             if (_block) {
                 _block(location,address);
             }

             if (_geocodeBlock) {
                 _geocodeBlock(location,address);
             }
             
             
             // 10分钟后自动清除位置信息
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(600 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 _address = nil;
                 _location = nil;
             });
         }
     }];
}

@end




@implementation HDAnnotation


@end


@implementation HDAnnotationView
{
    UILabel *_titleLabel;
}
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {

        // 在大头针旁边加一个label
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -15, 50, 20)];
        _titleLabel.font = kFontWithName(kFontNamePingFangSCMedium, 14);
        _titleLabel.textColor = kColorDark;
        _titleLabel.shadowColor = [UIColor whiteColor];
        _titleLabel.shadowOffset = CGSizeMake(-1, -1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_bottom);
            make.width.mas_lessThanOrEqualTo(kScreenWidth-60);
        }];

    }
    return self;

}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

@end

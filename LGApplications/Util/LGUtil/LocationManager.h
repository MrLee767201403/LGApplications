//
//  LocationManager.h
//  Trainee
//
//  Created by 李刚 on 2018/6/27.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


typedef void(^LocationBlock)(CLLocation *location,NSString *address);

@interface LocationManager : NSObject<CLLocationManagerDelegate>

+ (LocationManager *)shareManager;

/**  如果以前有位置直接返回旧的*/
- (void)getLocation:(LocationBlock)handle;
/**  重新定位更新位置*/
- (void)updateLocation:(LocationBlock)handle;
/**  反地理编码，解析地址*/
- (void )reverseGeocodeLocation:(CLLocation *)location complete:(LocationBlock)handle;
@end




@interface HDAnnotation : NSObject<MKAnnotation>
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *title;
@end


@interface HDAnnotationView : MKAnnotationView
@property (nonatomic,copy) NSString *title;
@end

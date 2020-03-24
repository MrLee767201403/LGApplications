# LGApplications
个人demo集合 未完待续

下载后找不到PCH文件的,可以在 Build Settings里搜索prefix header, 然后 设置 Precompile Prefix Header 为YES; 再设置 Prefix Header 路径, 双击后,直接把左侧的PrefixHeader.pch拉进弹框里,回车就OK了. 不明白的参考http://blog.csdn.net/lg767201403/article/details/72910696 这篇博客

将自己自定义的一些控件,写成demo,有需要的朋友可以拿来参考

LGApplications/Util/LGViews     :   自定义View

LGApplications/Util/Category    :   里面都是项目中常用的,几乎每个项目必备

LGApplications/Util/LGUtil      :   一些常用的公有方法 工具类

LGApplications/Util/UIDefines.h :   常用的宏

注:       里面用到最常用的两个框架SDWebImage 和 Masonry

申明:     项目内容仅供参考,使用过程中带来任何bug,概不负责

### 1.LGActionSheet                 
类似微信的那个底部弹窗,使用简单方便

### 2.LGPickerView                 
滑动选择器,支持自定义选项,日期,地区三种样式,自定义选项只需要传进去options数组即可

![image](https://github.com/MrLee767201403/LGApplications/blob/master/Gif/pickerView.png)


### 3.SingleChoiceTableView         
用tableView实现多个题目的单项选择,只提供一个思路,毕竟具体项目需要不同

### 4.LGTextView                   
带placeholder的textView

### 5.LGGradientLabel               
渐变文字Label

### 6.LGAlertView                   
自定义的一个AlertView,默认显示取消和确定两个按钮,可以分别添加事间, 可以设置只显示一个确定按钮

```
LGAlertView *alert = [[LGAlertView alloc] initWithContent:@"这是两个按钮的弹窗"];
alert.yesHandle = ^{
        [LGToastView showToastWithSuccess:@"点击了确定"];
};
alert.noHandle = ^{
        [LGToastView showToastWithSuccess:@"点击了取消"];
};
[alert show];
```

![image](https://github.com/MrLee767201403/LGApplications/blob/master/Gif/alertView.png)

### 8.LGRollView                    
自动循环滚动的广告条

### 9.ScrollView/TableView嵌套

![image](https://github.com/MrLee767201403/LGApplications/blob/master/Gif/scrollViews.gif)

### 10.CommonCell
通用的 Cell 可以添加头像 title  点击事件

![image](https://github.com/MrLee767201403/LGApplications/blob/master/Gif/CommonCell.png)

### 11.TextViewCell
通用的 textCell 可以添加头像 title  输入文本 支持多行

![image](https://github.com/MrLee767201403/LGApplications/blob/master/Gif/TextCell未输入.png)

输入多行文字后

![image](https://github.com/MrLee767201403/LGApplications/blob/master/Gif/TextCell输入多行文字.png)

### 12.LocationManager

获取当前位置并解析出地址

### 13.IndexSectionView

自定义tableView 右侧索引 

![image](https://github.com/MrLee767201403/LGApplications/blob/master/Gif/indexView.png)


### 14.LGToastView

类似MBProgressHUD消息弹窗 2秒后自动消失
```
+ (instancetype)showToastWithError:(NSString *)error;
+ (instancetype)showToastWithSuccess:(NSString *)success;
+ (instancetype)showToastWithError:(NSString *)error afterDelay:(NSTimeInterval)delay;
+ (instancetype)showToastWithSuccess:(NSString *)success afterDelay:(NSTimeInterval)delay;
```

### 15.LGImageManager
图片管理器 
- 检测相册相机权限
- 获取相册相机权限
- 获取相册所有图片资源 , 根据图片资源获取图片 (支持获取原图, 指定大小图片)
- 保存图片
```
+ (PHAuthorizationStatus)authorizationStatus;  // 相册权限
+ (AVAuthorizationStatus)cameraAuthorizationStatus;  // 相机权限
+ (void)requestAuthorizationWithType:(UIImagePickerControllerSourceType)type allowed:(void (^)(BOOL allowed))result; // 请求权限



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

@end
```


### 16.LGNotificationManager
本地通知   默认周一到周五每天早上九点半 发送签到通知 可以根据自己需求修改 若要开启通知 调用`resetCheckinNotifications`即可

```
/** 设置签到通知*/
- (void)resetCheckinNotifications;  // 每次九点半以前签到成功的时候调用
- (void)cancelAllNotification;
- (void)cancelNotificationWithIdentifier:(NSString *)identifier;
- (void)removeAllDeliveredNotifications __IOS_AVAILABLE(10.0);
```

### 17.LGRangeSlider
双向滑竿 用于选择范围 详见 `SliderDemo`
```oc
@interface LGRangeSlider : UIControl
@property (nonatomic, strong) UIColor *tintColor;  //
@property (nonatomic, strong) UIColor *trackColor;

@property (nonatomic, strong) UIImageView *minView; // 左边的滑动点
@property (nonatomic, strong) UIImageView *maxView; // 右边的滑动点

/**  最小值 默认16*/
@property (nonatomic, assign) NSInteger minValue;

/**  最大值 默认99*/
@property (nonatomic, assign) NSInteger maxValue;

/**  选中最小值 默认18*/
@property (nonatomic, assign) NSInteger selectedMinValue;

/**  选中最大值 默认26*/
@property (nonatomic, assign) NSInteger selectedMaxValue;

@end
```


### 17.LGSwitch  
自定义开关 可以随意设置大小
```
/** 开关开启状态的顶部滑块颜色 默认是白色 */
@property (nonatomic, strong) UIColor *onTintColor;
/** 开关开启状态的底部背景颜色 默认是红色 */
@property (nonatomic, strong) UIColor *onBackgroundColor;
/** 开关关闭状态的顶部滑块颜色 默认是白色 */
@property (nonatomic, strong) UIColor *offTintColor;
/** 开关关闭状态的底部背景颜色 默认是灰色 */
@property (nonatomic, strong) UIColor *offBackgroundColor;
/** 开关的风格颜色 边框颜色 默认是白色 */
@property(nonatomic, strong) UIColor *tintColor;
/** 查看开关打开状态, 默认为关闭 */
@property (nonatomic, getter=isOn) BOOL on;

/** 设置开关状态, animated : 是否有动画 不响应事件，只有点击的时候才会响应 */
- (void)setOn:(BOOL)newOn animated:(BOOL)animated;

/** delegate */
@property (nonatomic, weak) id <LGSwitchDelegate> delegate;
```
开关状态变化的代理
```
- (void)switchValueChange:(LGSwitch *)mineSwitch on:(BOOL)on;
```


### LGInputView
可以自动跟随键盘，并且可以自动换行的输入框，当达到最大高度时，变成内容可滑动，详见 `InputViewDemo`

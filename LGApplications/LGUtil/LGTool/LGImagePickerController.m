//
//  LGImagePickerController.m
//  HumanResource
//
//  Created by 李刚 on 2019/10/19.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "LGImagePickerController.h"
#import "LGImageManager.h"

@interface LGImagePickerController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *photoAssets;
@property (nonatomic, strong) UIView *errorView;

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancnelButton;

@end

@implementation LGImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
    self.navBar.backgroundColor = kColorWhite;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 110, 44)];
    self.titleLabel.font = kFontNavigation;
    self.titleLabel.text = @"相机胶卷";
    self.titleLabel.textColor = kColorDark;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.centerX = kScreenWidth/2.0;

    self.cancnelButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-71, kStatusBarHeight, 61, 44)];
    self.cancnelButton.titleLabel.font = kFontWithSize(12);
    [self.cancnelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancnelButton setTitleColor:kColorRed forState:UIControlStateNormal];
    [self.cancnelButton addTarget:self action:@selector(cancnelButtonEvent) forControlEvents:UIControlEventTouchUpInside];

    [self.navBar addSubview:self.titleLabel];
    [self.navBar addSubview:self.cancnelButton];
    [self.view addSubview:self.navBar];

//    self.title = @"相机胶卷";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" target:self action:@selector(cancnelButtonEvent)];
    // 布局
    CGFloat itemWH = (kScreenWidth-55)/4.0;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.itemSize = CGSizeMake(itemWH,itemWH);

    //
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, kScreenWidth, kViewHeight) collectionViewLayout:flowLayout];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, kBottomBarHeight, 0);
    [self.collectionView registerClass:[LGImageCell class] forCellWithReuseIdentifier:@"LGImageCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.collectionView];
    [self loadData];
}

- (void)gotoSetting{
    // iOS8以后 苹果出了新方法 可以直接打开到当前应用的设置界面，定位 通知 数据连接等都在一起
    [kApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    LGImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LGImageCell" forIndexPath:indexPath];
    cell.asset = self.photoAssets[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    PHAsset *asset = self.photoAssets[indexPath.row];
    [LGImageManager requestImageForAsset:asset size:CGSizeMake(asset.pixelWidth*0.5, asset.pixelHeight*0.5) completion:^(UIImage *image, NSDictionary *info) {
        if (self.complete) self.complete(image);
        [self cancnelButtonEvent];
    }];
}


- (void)loadData{
    // 已授权
    if ([LGImageManager authorizationStatus]==PHAuthorizationStatusAuthorized) {
        self.photoAssets = [LGImageManager getAllAssetInPhotoAlbumWithAscending:YES allowSelectVideo:NO allowSelectImage:YES allowSelectGif:NO allowSelectLivePhoto:NO limitCount:NSIntegerMax];
    }else{
        // 请求授权
        [LGImageManager requestAuthorizationWithType:UIImagePickerControllerSourceTypePhotoLibrary allowed:^(BOOL allowed) {
            // 同意
            if (allowed) {
                self.photoAssets = [LGImageManager getAllAssetInPhotoAlbumWithAscending:YES allowSelectVideo:NO allowSelectImage:YES allowSelectGif:NO allowSelectLivePhoto:NO limitCount:NSIntegerMax];
            }
            // 拒绝
            else{
                [NSUtil performBlockOnMainThread:^{
                    [self showErrorView];
                }];
            }
        }];
    }
}


- (void)setPhotoAssets:(NSArray *)photoAssets{
    _photoAssets = photoAssets;

    [NSUtil performBlockOnMainThread:^{
        [self hideErrorView:NO];
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.photoAssets.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }];

}


- (void)showErrorView{

    if (self.errorView == nil) {
        self.errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kViewHeight)];
        self.errorView.backgroundColor = kColorBackground;

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, kScreenWidth-30, 16)];
        titleLabel.font = kFontWithName(kFontNamePingFangSCMedium, 16);
        titleLabel.text = @"Please Allow Photo Assess";
        titleLabel.textColor = kColorDark;
        titleLabel.textAlignment = NSTextAlignmentCenter;


        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 75, kScreenWidth-80, 110)];
        textLabel.font = kFontWithSize(14);
        textLabel.text = @"请允许\"公信人力\"访问您的相册.\n\n前往 设置 > 隐私 > 照片 > 公信人力 > 读取和写入";
        textLabel.textColor = kColorGray;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 0;

        UIButton *authButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 200, kScreenWidth-30, 40)];
        authButton.titleLabel.font = kBoldFontWithName(kFontNamePingFangSCSemibold, 16);
        [authButton setTitle:@"允许访问" forState:UIControlStateNormal];
        [authButton setTitleColor:kColorWithFloat(0x007aff) forState:UIControlStateNormal];
        [authButton addTarget:self action:@selector(gotoSetting) forControlEvents:UIControlEventTouchUpInside];

        [self.errorView addSubview:titleLabel];
        [self.errorView addSubview:textLabel];
        [self.errorView addSubview:authButton];
    }
    self.errorView.alpha = 1;
    [self.view addSubview:self.errorView];
}

- (void)hideErrorView:(BOOL)animate{
    if (self.errorView && self.errorView.superview) {
        if (animate) {
            [UIView animateWithDuration:0.3 animations:^{
                self.errorView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.errorView removeFromSuperview];
            }];
        }else{
            [self.errorView removeFromSuperview];
        }
    }
}

- (void)cancnelButtonEvent{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end








@implementation LGImageCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}


- (void)setAsset:(PHAsset *)asset{
    _asset = asset;
    CGSize size = CGSizeMake(self.width * 1.7, self.height * 1.7);
    [LGImageManager requestImageForAsset:asset size:size completion:^(UIImage *image, NSDictionary *info) {
        self.imageView.image = image;
    }];
}

- (UIImage *)originalImage{

    if (_originalImage == nil) {
        [LGImageManager requestOriginalImageForAsset:self.asset completion:^(UIImage *image, NSDictionary *info) {
            self->_originalImage = image;
        }];
    }
    return _originalImage;
}
@end


#import "LGCollectionViewFlowLayout.h"

@interface LGCollectionViewFlowLayout ()
@property (nonatomic, assign) CGRect lastFrame; // 上一个item的 布局
@property (nonatomic, strong) NSMutableArray *attributesArray;
@end

@implementation LGCollectionViewFlowLayout

- (void)prepareLayout{

    [super prepareLayout];

    NSMutableArray *layoutInfoArr = [NSMutableArray array];
    // 获取布局信息
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++){
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *subArr = [NSMutableArray arrayWithCapacity:numberOfItems];

        // item
        for (NSInteger item = 0; item < numberOfItems; item++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [subArr addObject:attributes];
        }

        // header & footer
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if(headerAttributes)  [layoutInfoArr addObject:@[headerAttributes]];

        UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
        if(footerAttributes)  [layoutInfoArr addObject:@[footerAttributes]];

        // 添加到二维数组
        [layoutInfoArr addObject:[subArr copy]];
    }
    // 存储布局信息
    self.attributesArray = [layoutInfoArr copy];
}

// 直接使用系统计算的大小 不做更新了
//- (CGSize)collectionViewContentSize{
//    return self.contentSize;
//}


//// 找出了与指定区域有交接的UICollectionViewLayoutAttributes对象放到一个数组中，然后返回
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *layoutAttributesArr = [NSMutableArray array];
    [self.attributesArray enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger i, BOOL * _Nonnull stop) {
        [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(CGRectIntersectsRect(obj.frame, rect)) { // 如果 item 在rect内
                [layoutAttributesArr addObject:obj];
            }
        }];
    }];
    return layoutAttributesArr;
}


/* 这里只自定义了item 如果需要自定义分区头部尾部*/
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

    // 拿到系统为我们计算的布局
    UICollectionViewLayoutAttributes *oldAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];


    // 原样返回
    if (indexPath.section == 1) {
        return oldAttributes;
    }

    // 创建一个我们期望的布局
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    // sectionInset  minimumLineSpacing  minimumInteritemSpacing 代理拿不到 需要自己赋值
    CGFloat itemX = self.sectionInset.left;         // 默认X值
    CGFloat itemY = oldAttributes.frame.origin.y;   // Y值直接用系统算的
    CGSize itemSize = oldAttributes.size;           // 大小值直接用系统算(通过代理返回的大小)

    // 不换行 && (indexPath.row=0时  self.lastFrame 还未赋值)  调整X值
    if (oldAttributes.frame.origin.x != itemX && indexPath.row != 0) {
        itemX =  self.lastFrame.origin.x + self.lastFrame.size.width + self.minimumLineSpacing;
    }
    // 赋值
    attributes.frame = CGRectMake(itemX, itemY, itemSize.width, itemSize.height);

    // 更新上一个item的位置
    self.lastFrame = CGRectMake(itemX, itemY, itemSize.width, itemSize.height);

    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}


- (NSMutableArray *)attributesArray{
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}
@end

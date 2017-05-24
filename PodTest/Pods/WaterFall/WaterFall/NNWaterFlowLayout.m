//
//  NNWaterFlowLayout.m
//  瀑布流
//
//  Created by xiangtai on 15/6/26.
//  Copyright (c) 2015年 何凯楠. All rights reserved.
//

#import "NNWaterFlowLayout.h"

////列间距
//static const CGFloat columMarign = 10;
////行间距
//static const CGFloat rowMarign = 10;

@interface NNWaterFlowLayout()

/*这个字典用来存储每一列的最大Y值（每一列的高度）*/
@property (nonatomic , strong) NSMutableDictionary *maxYDic;
@property (nonatomic , strong) NSMutableArray *attrsArray;

@end

@implementation NNWaterFlowLayout

-(NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

-(NSMutableDictionary *)maxYDic
{
    if (!_maxYDic) {
        _maxYDic = [[NSMutableDictionary alloc] init];
    }
    return _maxYDic;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.columMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.columsCount = 3;
    }
    return self;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 *  布局前的准备工作
 */
-(void)prepareLayout
{
    [super prepareLayout];
    
    //清空最大Y值
    for (int i = 0; i < self.columsCount; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        self.maxYDic[key] = @(self.sectionInset.top);
    }
    
    //计算所有item的属性
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
}

/**
 *  返回所有的尺寸
 */
-(CGSize)collectionViewContentSize
{
    //假设最大的那一列是第0列
    __block NSString *maxColumn = @"0";
    //找出最大的那一列
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.maxYDic[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    CGFloat height = [self.maxYDic[maxColumn] floatValue] + self.sectionInset.bottom;
    return CGSizeMake(0, height);
}

/**
 *  返回indexPath所在的item的位置
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //假设最短的那一列是第0列
    __block NSString *minColumn = @"0";
    //找出最短的那一列
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] < [self.maxYDic[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    
    //计算尺寸
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columsCount - 1) * self.columMargin) / self.columsCount;
    
    CGFloat height = [self.delegate waterFlowLayout:self heightForWidth:width atIndexPath:indexPath];
    
    //计算位置
    CGFloat x = self.sectionInset.left + (width + self.columMargin) * [minColumn intValue];
    
    CGFloat y = [self.maxYDic[minColumn] floatValue] + self.rowMargin;
    
    //更新这一列的最大Y值
    self.maxYDic[minColumn] = @(y + height);
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    
    return attrs;
}

/**
 *  返回rect范围内的UICollectionViewLayoutAttributes
 */
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

@end

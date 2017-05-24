//
//  NNWaterFlowLayout.h
//  瀑布流
//
//  Created by xiangtai on 15/6/26.
//  Copyright (c) 2015年 何凯楠. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NNWaterFlowLayout;
@protocol NNWaterFlowLayoutDelegate <NSObject>

-(CGFloat)waterFlowLayout:(NNWaterFlowLayout *)waterFlowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end

@interface NNWaterFlowLayout : UICollectionViewLayout

/*每一列的间距*/
@property (nonatomic , assign) CGFloat columMargin;
/*每一行的间距*/
@property (nonatomic , assign) CGFloat rowMargin;
/*每个item之间的间距*/
@property (nonatomic , assign) UIEdgeInsets sectionInset;
/*有几列*/
@property (nonatomic , assign) int columsCount;

@property (nonatomic , weak) id<NNWaterFlowLayoutDelegate> delegate;

@end

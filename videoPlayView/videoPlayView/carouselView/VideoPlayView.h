//
//  VideoPlayView.h
//  videoPlayView
//
//  Created by 刘长洋 on 2020/1/16.
//  Copyright © 2020 刘长洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 点击回调

 @param curIndex 点击的下标
 */
typedef void(^videoPlayViewBlock)(NSInteger curIndex);

@interface VideoPlayView : UIView

//点击回调
@property (nonatomic, strong) videoPlayViewBlock videoPlayViewBlock;

/**
 初始化
 
 @param frame 位置
 @return 轮播图
 */
- (id)initWithFrame:(CGRect)frame;

/**
 数据源
 
 @param dataArr 数据源
 */
- (void)setCarouseDataArr:(NSArray *)dataArr;

@end

NS_ASSUME_NONNULL_END

//
//  Model.h
//  videoPlayView
//
//  Created by 刘长洋 on 2020/1/16.
//  Copyright © 2020 刘长洋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject

+ (id)safeWithDic:(NSDictionary *)dic;

@end

#pragma mark ---------------------------------------- AdListmodel ----------

@interface AdListmodel : Model

//广告id
@property (nonatomic, assign) int pkId;
//广告图片
@property (nonatomic, strong) NSString *img;
//名称
@property (nonatomic, strong) NSString *name;
//跳转内容（url/富文本/视频链接）
@property (nonatomic, strong) NSString *jumpContent;
//广告code
@property (nonatomic, strong) NSString *adCode;
//跳转类型（0url 1富文本 2视频）
@property (nonatomic, assign) int jumpType;

@end

NS_ASSUME_NONNULL_END

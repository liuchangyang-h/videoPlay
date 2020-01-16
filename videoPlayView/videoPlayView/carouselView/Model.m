//
//  Model.m
//  videoPlayView
//
//  Created by 刘长洋 on 2020/1/16.
//  Copyright © 2020 刘长洋. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (id)safeWithDic:(NSDictionary *)dic
{
    return dic;
}

@end

@implementation AdListmodel

+ (id)safeWithDic:(NSDictionary *)dic
{
    AdListmodel *model = [[AdListmodel alloc] initWithDic:dic];
    return model;
}

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    self.pkId = [[dic objectForKey:@"pkId"] intValue];
    self.img = [dic objectForKey:@"img"];
    self.name = [dic objectForKey:@"name"];
    self.jumpContent = [dic objectForKey:@"jumpContent"];
    self.adCode = [dic objectForKey:@"adCode"];
    self.jumpType = [[dic objectForKey:@"jumpType"] intValue];
    
    return self;
}

@end

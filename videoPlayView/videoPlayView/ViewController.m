//
//  ViewController.m
//  videoPlayView
//
//  Created by 刘长洋 on 2020/1/16.
//  Copyright © 2020 刘长洋. All rights reserved.
//

#import "ViewController.h"
#import "VideoPlayView.h"
#import "Model.h"

@interface ViewController ()

//轮播图
@property (nonatomic, strong) VideoPlayView *playView;
//轮播数组
@property (nonatomic, strong) NSMutableArray *imgArray;

@end

@implementation ViewController

#pragma mark - System

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imgArray = [[NSMutableArray alloc] init];
    
    [self initView];
}

#pragma mark - LoadView

- (void)initView
{
    //轮播图
    {
        __weak ViewController *selfBlock = self;
        self.playView = [[VideoPlayView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, (self.view.bounds.size.width - 20)*9/16 + 20)];
        [self.playView setBackgroundColor:[UIColor clearColor]];
        [self.playView setVideoPlayViewBlock:^(NSInteger curIndex) {
            
            [selfBlock adImageDidClickedAtIndex:(int)curIndex];
            
        }];
        [self.view addSubview:self.playView];
    }
    
    [self bannerList];
}

- (void)adImageDidClickedAtIndex:(int)index
{
    NSLog(@"选择第几个:%d",index);
}

- (void)bannerList
{
    [self.imgArray removeAllObjects];

    for (int i = 0; i < 4; i++)
    {
        AdListmodel *model = [[AdListmodel alloc] init];
        if (i == 0)
        {
            model.img = @"http://img.ptocool.com/3332-1518523974126-29";
            model.jumpContent = @"http://wvideo.spriteapp.cn/video/2016/1117/5cd90c96-acb0-11e6-b83b-d4ae5296039d_wpc.mp4";
            model.jumpType = 2;
        }
        else if (i == 3)
        {
            model.img = @"http://img.ptocool.com/3332-1518523974126-29";
            model.jumpContent = @"http://medicineonline.oss-cn-hangzhou.aliyuncs.com/video/SCEB4Rz2RP.mp4";
            model.jumpType = 2;
        }
        else
        {
            model.img = @"http://img.ptocool.com/3332-1518523974126-29";
            model.jumpType = 0;
        }
        [self.imgArray addObject:model];
    }
    [self.playView setCarouseDataArr:self.imgArray];
}


@end

//
//  VideoPlayView.m
//  videoPlayView
//
//  Created by 刘长洋 on 2020/1/16.
//  Copyright © 2020 刘长洋. All rights reserved.
//

#import "VideoPlayView.h"
#import <AVKit/AVKit.h>
#import "Model.h"
#import "UIImageView+WebCache.h"
//网络默认图
#define kImage                                        [UIImage imageNamed:@"placeholderImage"]
//网络图片
#define kImage_Url(url)                               [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]

@interface VideoPlayView ()<UIScrollViewDelegate>
//容器
@property (nonatomic, strong) UIScrollView *scrollView;
//
@property (nonatomic, strong) UIPageControl *pageControl;
//当前下标
@property (nonatomic, assign) NSInteger curIndex;
//记录
@property (nonatomic, assign) NSInteger recordIndex;
//数据源
@property (nonatomic, strong) NSArray *dataArr;
//占位图img
@property (nonatomic,strong) UIImageView *placeholderImg;
//
@property (nonatomic, strong) AdListmodel *listModel;
//视频view
@property (nonatomic, strong) UIView *videoV;
//视频图片
@property (nonatomic, strong) UIImageView *videoImgV;
//视频开始
@property (nonatomic, strong) UIButton *playBtn;
//重播
@property (nonatomic, strong) UILabel *replayLab;
/*
 * 播放器
 */
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation VideoPlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupViews];
    }
    return self;
}

#pragma mark - setupViews

- (void)setupViews
{
    self.listModel = [[AdListmodel alloc] init];
    {
        UIScrollView *sv = [[UIScrollView alloc] init];
        [sv setBackgroundColor:[UIColor clearColor]];
        [sv setFrame:CGRectMake(0, 0, self.bounds.size.width, (self.bounds.size.width - 20)*9/16)];
        [sv setPagingEnabled:YES];
        [sv setDelegate:self];
        [sv setShowsVerticalScrollIndicator:NO];
        [sv setShowsHorizontalScrollIndicator:NO];
        [sv setUserInteractionEnabled:YES];
        [self addSubview:sv];
        self.scrollView = sv;
    }
    
    {
        UIPageControl *page = [[UIPageControl alloc] init];
        [page setBackgroundColor:[UIColor clearColor]];
        [page setFrame:CGRectMake(0, 0, self.bounds.size.width - 20, 20)];
        [page setValue:[UIImage imageNamed:@"bg_huise"] forKeyPath:@"_pageImage"];
        [page setValue:[UIImage imageNamed:@"bg_gundong"] forKeyPath:@"_currentPageImage"];
        [self addSubview:page];
        self.pageControl = page;
    }
    //占位图
    {
        UIImageView *imgV = [[UIImageView alloc] init];
        [imgV setBackgroundColor:[UIColor clearColor]];
        [imgV setFrame:CGRectMake(10, 0, self.scrollView.bounds.size.width - 20, self.scrollView.bounds.size.height)];
        [imgV setContentMode:UIViewContentModeScaleAspectFill];
        [imgV.layer setMasksToBounds:YES];
        [imgV setImage:kImage];
        [self.scrollView addSubview:imgV];
        self.placeholderImg = imgV;
    }
}

#pragma mark - setters

- (void)setCarouseDataArr:(NSArray *)dataArr
{
    self.dataArr = [[NSArray alloc] init];
    if (dataArr.count > 0)
    {
        self.dataArr = dataArr;
        self.curIndex = 0;
        self.recordIndex = 0;
        
        if (self.dataArr.count > 1)
        {
            [self.pageControl setNumberOfPages:dataArr.count];
            [self.pageControl setCurrentPage:0];
            [self.pageControl setHidden:NO];
            [self.pageControl setFrame:CGRectMake(self.bounds.size.width - (dataArr.count)*25, self.bounds.size.height - 20,(dataArr.count)*25 ,20)];
        }
        else
        {
            [self.pageControl setHidden:YES];
        }
        
        AdListmodel *model = [self.dataArr objectAtIndex:0];
        
        if (model.jumpType == 2)
        {
            self.listModel = model;
            for (UIView *view in [self.videoV subviews])
            {
                [view removeFromSuperview];
            }
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:[UIColor blackColor]];
            [view setFrame:CGRectMake(10, 0, self.scrollView.bounds.size.width - 20, self.scrollView.bounds.size.height)];
            [view.layer setCornerRadius:5];
            [view setClipsToBounds:YES];
            [self.scrollView addSubview:view];
            self.videoV = view;
            //图片
            {
                UIImageView *imgV = [[UIImageView alloc] init];
                [imgV setBackgroundColor:[UIColor clearColor]];
                [imgV setFrame:view.bounds];
                [imgV sd_setImageWithURL:kImage_Url(model.img) placeholderImage:kImage];
                [imgV setUserInteractionEnabled:YES];
                [view addSubview:imgV];
                self.videoImgV = imgV;
            }
            {
                UIButton *btn = [[UIButton alloc] init];
                [btn setBackgroundColor:[UIColor clearColor]];
                [btn setImage:[UIImage imageNamed:@"jz_play_normal"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"jz_play_pressed"] forState:UIControlStateHighlighted];
                [btn setFrame:CGRectMake((self.videoImgV.bounds.size.width - btn.imageView.image.size.width)/2, (self.videoImgV.bounds.size.height - btn.imageView.image.size.height)/2, btn.imageView.image.size.width, btn.imageView.image.size.height)];
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.videoImgV addSubview:btn];
                self.playBtn = btn;
            }
        }
        else
        {
            UIImageView *imgV = [[UIImageView alloc] init];
            [imgV setBackgroundColor:[UIColor clearColor]];
            [imgV setFrame:CGRectMake(10, 0, self.scrollView.bounds.size.width - 20, self.scrollView.bounds.size.height)];
            [imgV setContentMode:UIViewContentModeScaleAspectFill];
            [imgV.layer setMasksToBounds:YES];
            [imgV sd_setImageWithURL:kImage_Url(model.img) placeholderImage:kImage];
            [imgV.layer setCornerRadius:5];
            [imgV setClipsToBounds:YES];
            [imgV setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick)];
            [imgV addGestureRecognizer:tap];
            [self.scrollView addSubview:imgV];
        }
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width * [dataArr count], self.scrollView.bounds.size.height)];
}

- (void)imgTapClick
{
    if (self.videoPlayViewBlock)
    {
        self.videoPlayViewBlock(_curIndex);
    }
}

- (void)btnAction:(UIButton *)btn
{
    for (UIView *view in [self.videoV subviews])
    {
        [view removeFromSuperview];
    }
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:kImage_Url(self.listModel.jumpContent)];
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [layer setFrame:self.videoV.bounds];
    [self.videoV.layer addSublayer:layer];

    [self.player play];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self.player replaceCurrentItemWithPlayerItem:item];
        // 播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpc_playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    });
}

- (void)vpc_playbackFinished:(NSNotification *)noti
{
    for (UIView *view in [self.videoV subviews])
    {
        [view removeFromSuperview];
    }
    //图片
    {
        UIImageView *imgV = [[UIImageView alloc] init];
        [imgV setBackgroundColor:[UIColor clearColor]];
        [imgV setFrame:self.videoV.bounds];
        [imgV sd_setImageWithURL:kImage_Url(self.listModel.img) placeholderImage:kImage];
        [imgV setUserInteractionEnabled:YES];
        [self.videoV addSubview:imgV];
        self.videoImgV = imgV;
    }
    {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setImage:[UIImage imageNamed:@"jz_restart_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"jz_restart_pressed"] forState:UIControlStateHighlighted];
        [btn setFrame:CGRectMake((self.videoImgV.bounds.size.width - btn.imageView.image.size.width)/2, (self.videoImgV.bounds.size.height - btn.imageView.image.size.height)/2, btn.imageView.image.size.width, btn.imageView.image.size.height)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.videoImgV addSubview:btn];
        self.playBtn = btn;
    }
    //重播
    {
        UILabel *lab = [[UILabel alloc] init];
        [lab setBackgroundColor:[UIColor clearColor]];
        [lab setFrame:CGRectMake(20, (self.videoImgV.bounds.size.height - self.playBtn.imageView.image.size.height)/2 + self.playBtn.bounds.size.height + 5, self.videoImgV.bounds.size.width - 40, 20)];
        [lab setText:@"重播"];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont systemFontOfSize:14]];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [self.videoImgV addSubview:lab];
        self.replayLab = lab;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _curIndex = scrollView.contentOffset.x/scrollView.bounds.size.width;

    if (_curIndex == _recordIndex)
    {
        return;
    }
    _recordIndex = _curIndex;
    AdListmodel *model = [self.dataArr objectAtIndex:_curIndex];

    if (model.jumpType == 5)
    {
        self.listModel = model;
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor blackColor]];
        [view setFrame:CGRectMake(10 + scrollView.contentOffset.x, 0, self.scrollView.bounds.size.width - 20, self.scrollView.bounds.size.height)];
        [view.layer setCornerRadius:5];
        [view setClipsToBounds:YES];
        [self.scrollView addSubview:view];
        self.videoV = view;
        //图片
        {
            UIImageView *imgV = [[UIImageView alloc] init];
            [imgV setBackgroundColor:[UIColor clearColor]];
            [imgV setFrame:view.bounds];
            [imgV sd_setImageWithURL:kImage_Url(model.img) placeholderImage:kImage];
            [imgV setUserInteractionEnabled:YES];
            [view addSubview:imgV];
            self.videoImgV = imgV;
        }
        {
            UIButton *btn = [[UIButton alloc] init];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setImage:[UIImage imageNamed:@"jz_play_normal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"jz_play_pressed"] forState:UIControlStateHighlighted];
            [btn setFrame:CGRectMake((self.videoImgV.bounds.size.width - btn.imageView.image.size.width)/2, (self.videoImgV.bounds.size.height - btn.imageView.image.size.height)/2, btn.imageView.image.size.width, btn.imageView.image.size.height)];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.videoImgV addSubview:btn];
            self.playBtn = btn;
        }
    }
    else
    {
        [self.player pause];
        UIImageView *imgV = [[UIImageView alloc] init];
        [imgV setBackgroundColor:[UIColor clearColor]];
        [imgV setFrame:CGRectMake(10 + scrollView.contentOffset.x, 0, self.scrollView.bounds.size.width - 20, self.scrollView.bounds.size.height)];
        [imgV setContentMode:UIViewContentModeScaleAspectFill];
        [imgV.layer setMasksToBounds:YES];
        [imgV sd_setImageWithURL:kImage_Url(model.img) placeholderImage:kImage];
        [imgV.layer setCornerRadius:5];
        [imgV setClipsToBounds:YES];
        [imgV setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick)];
        [imgV addGestureRecognizer:tap];
        [self.scrollView addSubview:imgV];
    }
    [self.pageControl setCurrentPage:_curIndex];
}

@end

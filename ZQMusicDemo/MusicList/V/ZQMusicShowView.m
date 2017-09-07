//
//  ZQMusicShowView.m
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/6.
//  Copyright © 2017年 BTV. All rights reserved.
//

#define kLrcLineHeight 44


#import "ZQMusicShowView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <YYModel.h>
#import <MJExtension.h>

#import "ZQLabel.h"
#import "ZQMusicModel.h"
#import "ZQMusicTool.h"
#import "ZQPlayerTool.h"
#import "ZQLyricTool.h"
#import "ZQLrcModel.h"
#import "CALayer+PauseAimate.h"


@interface ZQMusicShowView ()<UIScrollViewDelegate>



/**
 播放
 */
@property (weak, nonatomic) IBOutlet UIButton *play;


/**
 暂停
 */
@property (weak, nonatomic) IBOutlet UIButton *pause;


/**
 背景图
 */
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;


/**
 歌名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


/** 歌曲信息 */
@property (weak, nonatomic) IBOutlet UIView *groupView;
// 专辑
@property (weak, nonatomic) IBOutlet UILabel *zhuanjiNameLabel;
// 歌手
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
// 歌词
@property (weak, nonatomic) IBOutlet ZQLabel *lrcLabel;
/** 当前播放时间的label */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
/** 专辑图片的View */
@property (weak, nonatomic) IBOutlet UIImageView *zhuanjiImageView;
/** 进度条的视图 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/** 总时间的Label */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


/**
 歌词
 */
@property (weak, nonatomic) IBOutlet UIScrollView *lrcScrollView;


@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger currentLrcIndex;


//一首歌的所有行的歌词
@property (nonatomic, strong) NSArray *allLrcLines;

@property (nonatomic, strong) NSTimer *timer;


@end

@implementation ZQMusicShowView

+(ZQMusicShowView *)instanceMusicShowView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZQMusicShowView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //背景图毛玻璃效果
    [self grammaticalizationBackImageView];
    
    //初始化UI
    [self initializeView];

    //刷新UI
    [self layoutUI];
    
    //后台返回监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnterForeground) name:@"EnterForeground" object:nil];

    
}


#pragma mark --背景图毛玻璃效果
- (void)grammaticalizationBackImageView
{
    //毛玻璃效果
    UIToolbar *bar = [[UIToolbar alloc]init];
    bar.barStyle = UIBarStyleBlack;
    bar.translucent = YES;
    //禁止掉 Autoresizing
    bar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.backImageView addSubview:bar];
    
    NSArray *consH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : bar}];
    NSArray *consV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : bar}];
    
    //添加约束原则?
    [self.backImageView addConstraints:consH];
    [self.backImageView addConstraints:consV];
}



#pragma mark --初始化UI
- (void)initializeView
{
    self.zhuanjiImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.zhuanjiImageView.layer.cornerRadius = self.zhuanjiImageView.frame.size.width*0.5;
    self.zhuanjiImageView.clipsToBounds = YES;
    
    
    self.scrollView.contentSize = CGSizeMake(self.groupView.bounds.size.width * 2, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    [self.lrcScrollView setContentSize:CGSizeMake(0, self.allLrcLines.count *kLrcLineHeight)];
    [self.lrcScrollView setContentInset:UIEdgeInsetsMake(100, 0, self.lrcScrollView.bounds.size.height * 0.5 , 0)];
    [self addIconViewAnimate];
}



#pragma mark --刷新界面
- (void)layoutUI
{
    ZQMusicModel *model = [[ZQMusicTool shareMusicTool] playingMusic];
    
    self.nameLabel.text = model.name;
    self.singerLabel.text = model.singer;
    self.zhuanjiNameLabel.text = model.zhuanji;
    self.zhuanjiImageView.image = [UIImage imageNamed:model.image];
    
    self.backImageView.image = [UIImage imageNamed:model.image];
    self.totalTimeLabel.text = [[ZQPlayerTool sharePlayerTool] durationMusicString];
    self.allLrcLines = [ZQLyricTool lyricListWithName:model.lrc];
    
    // 设置全屏歌词
    [self updateLrcLineLabelForScrollView];
    [self addMusicTimer];
    
    if ([[ZQPlayerTool sharePlayerTool] isplaying]) {
        
        self.play.hidden = YES;
        self.pause.hidden = NO;
        
    }else
    {
        self.play.hidden = NO;
        self.pause.hidden = YES;
        [self.zhuanjiImageView.layer pauseAnimate];

    }

    
}


#pragma mark --更新歌词
-(void)updateLrcLineLabelForScrollView {
    
    for (id obje in self.lrcScrollView.subviews) {
        if ([obje isKindOfClass:[ZQLabel class]]) {
            
            [obje removeFromSuperview];
        }
    }
    
    for (int i = 0; i < self.allLrcLines.count; i++) {
        
        ZQLrcModel *lrcModel = self.allLrcLines[i];
        
        ZQLabel *label = [[ZQLabel alloc]init];
        
        label.currentIndex = i;
        
        label.text = lrcModel.text;
        
        label.textColor = [UIColor whiteColor];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.lrcScrollView addSubview:label];
        
        // 设置约束
        label.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *labelH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[label]" options:0 metrics:nil views:@{@"label" : label}];
        NSArray *labelV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[label]" options:0 metrics:@{@"margin" : @(kLrcLineHeight * i)} views:@{@"label" : label}];
        NSLayoutConstraint *labelW = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.lrcScrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        
        [self.lrcScrollView addConstraints:labelH];
        [self.lrcScrollView addConstraints:labelV];
        [self.lrcScrollView addConstraint:labelW];
        
    }
}

// 定时器
-(void)addMusicTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0 target:self selector:@selector(updatePerSecond) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
// 每秒执行一次
-(void)updatePerSecond{
    
    self.lrcLabel.text = @"QQ音乐";
    
    self.currentTimeLabel.text = [[ZQPlayerTool sharePlayerTool] currentTimeString];
    
    self.progressView.progress = [[ZQPlayerTool sharePlayerTool] musicProgress];
    
    NSTimeInterval currentTime = [[ZQPlayerTool sharePlayerTool] currentTime];
    
    for (int i = 0; i < self.allLrcLines.count; i++) {
        
        ZQLrcModel *cureetModel = self.allLrcLines[i];
        
        ZQLrcModel *nextModel = nil;
        if (i == self.allLrcLines.count - 1) {
            nextModel = self.allLrcLines[i];
        }else {
            nextModel = self.allLrcLines[i+1];
        }
        if (currentTime >= cureetModel.time && currentTime < nextModel.time ) {
            
            self.lrcLabel.text = cureetModel.text;
            
            self.currentLrcIndex = i;
            
            self.lrcLabel.progress =  (currentTime-cureetModel.time)/(nextModel.time - cureetModel.time);
            
            for (id objec in self.lrcScrollView.subviews) {
                
                if ([objec isKindOfClass:[ZQLabel class]]) {
                    ZQLabel *Label = (ZQLabel *)objec;
                    if (Label.currentIndex == i ) {
                        Label.progress = self.lrcLabel.progress;
                        Label.font = [UIFont systemFontOfSize:15];
                    }else {
                        Label.progress = 0;
                        Label.font = [UIFont systemFontOfSize:15];
                    }
                }
            }
        }
    }
       
    [self.lrcScrollView setContentOffset:CGPointMake(0, -100 + kLrcLineHeight * self.currentLrcIndex)];
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        
        self.groupView.alpha = 1 - self.scrollView.contentOffset.x / self.groupView.bounds.size.width;
    }
}



#pragma mark --顶部按钮点击事件
- (IBAction)disMIss:(id)sender {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self]; 
    [self removeFromSuperview];
    
    
}
- (IBAction)moreBtnClick:(id)sender {
    
    
    
}



#pragma mark - 播放器操作
// 点击播放
- (IBAction)clickPlay {
    
    
    // 界面逻辑
    self.play.hidden = YES;
    self.pause.hidden = NO;
    
    
    ZQMusicModel *model = [[ZQMusicTool shareMusicTool] playingMusic];

    [[ZQPlayerTool sharePlayerTool] playMusicWithMusicName:model.mp3];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0 target:self selector:@selector(updatePerSecond) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    [self.zhuanjiImageView.layer resumeAnimate];

    
}

// 点击暂停
- (IBAction)clickPause {
    self.play.hidden = NO;
    self.pause.hidden = YES;
    
    [[ZQPlayerTool sharePlayerTool] pause];
    [self.timer invalidate];
    self.timer = nil;
    [self.zhuanjiImageView.layer pauseAnimate];

    
}


// 点击上一曲
- (IBAction)clickPer {
    

    ZQMusicModel *model = [[ZQMusicTool shareMusicTool] previousMusic];
    [[ZQMusicTool shareMusicTool] setUpPlayingMusic:model];
    [self clickPlay];
    [self layoutUI];
    
}
// 点击下一曲
- (IBAction)clickNext {
    
    ZQMusicModel *model = [[ZQMusicTool shareMusicTool] nextMusic];
    [[ZQMusicTool shareMusicTool] setUpPlayingMusic:model];
    [self clickPause];
    [self clickPlay];
    [self layoutUI];


}



#pragma mark - 添加zhuanjiImageView的动画
- (void)addIconViewAnimate
{
    CABasicAnimation *rotateAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimate.fromValue = @(0);
    rotateAnimate.toValue = @(M_PI * 2);
    rotateAnimate.repeatCount = NSIntegerMax;
    rotateAnimate.duration = 36;
    [self.zhuanjiImageView.layer addAnimation:rotateAnimate forKey:nil];
}


/**
 回到前台
 */
- (void)EnterForeground
{
    [self layoutUI];
}


@end

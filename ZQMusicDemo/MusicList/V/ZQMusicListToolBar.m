//
//  ZQMusicListToolBar.m
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/4.
//  Copyright © 2017年 BTV. All rights reserved.
//

#define margin 10

#import "ZQMusicListToolBar.h"
#import "ZQMusicModel.h"
#import "ZQMusicTool.h"
#import "ZQPlayerTool.h"
#import "CALayer+PauseAimate.h"

@interface ZQMusicListToolBar ()


@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *singerLabel;




@end


@implementation ZQMusicListToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] init];
        [self addSubview:_nameLabel];
        
        _singerLabel = [[UILabel alloc] init];
        [self addSubview:_singerLabel];
        
        _palyBtn  = [[UIButton alloc] init];
        [self addSubview:_palyBtn];
        
        
        _listBtn = [[UIButton alloc] init];
        [self addSubview:_listBtn];
        
        
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = CGRectMake(margin * 0.5, margin * 0.5, 40, 40);
    _imageView.layer.cornerRadius = 20;
    _imageView.clipsToBounds = YES;
    
    CGFloat nameLabelX = CGRectGetMaxX(_imageView.frame) + margin;
    CGFloat nameLabelY = margin;
    CGFloat nameLabelW = ScreenWidth - nameLabelX - 50;
    CGFloat nameLabelH = 15;
    _nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    _nameLabel.textColor = BlackColor;
    _nameLabel.font = ZQFont(13);
    
    
    
    
    CGFloat singerLabelX = nameLabelX;
    CGFloat singerLabelY = CGRectGetMaxY(_nameLabel.frame);
    CGFloat singerLabelW = nameLabelW;
    CGFloat singerLabelH = 15;
    _singerLabel.frame = CGRectMake(singerLabelX, singerLabelY, singerLabelW, singerLabelH);
    _singerLabel.textColor = BlackColor;
    _singerLabel.font = ZQFont(13);
    
    
    CGFloat listBtnW = 50;
    CGFloat listBtnH = listBtnW;
    CGFloat listBtnX = ScreenWidth - listBtnW - margin;
    _listBtn.frame = CGRectMake(listBtnX, 0, listBtnW, listBtnH);
    [_listBtn setImage:[UIImage imageNamed:@"listBtn"] forState:UIControlStateNormal];
    [_listBtn addTarget:self action:@selector(listBtnClickWith:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    CGFloat palyBtnW = 50;
    CGFloat palyBtnH = palyBtnW;
    CGFloat palyBtnX = listBtnX - palyBtnW - margin;
    _palyBtn.frame = CGRectMake(palyBtnX, 0, palyBtnW, palyBtnH);
    [_palyBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_palyBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
    [_palyBtn addTarget:self action:@selector(playBtnClickWith:) forControlEvents:UIControlEventTouchUpInside];
    

    
}


- (void)setMusicModel:(ZQMusicModel *)musicModel
{
    _musicModel = musicModel;
    
    _imageView.image = [UIImage imageNamed:musicModel.image];

    _nameLabel.text = musicModel.name;

    _singerLabel.text = musicModel.singer;
    
    [self addIconViewAnimate];

    [self stopAnimate];

}



#pragma mark - 添加iconView的动画
- (void)addIconViewAnimate
{
    CABasicAnimation *rotateAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimate.fromValue = @(0);
    rotateAnimate.toValue = @(M_PI * 2);
    rotateAnimate.repeatCount = NSIntegerMax;
    rotateAnimate.duration = 36;
    [self.imageView.layer addAnimation:rotateAnimate forKey:nil];
}


- (void)stopAnimate
{
    [self.imageView.layer pauseAnimate];
}

- (void)resumeAnimate
{
    [self.imageView.layer resumeAnimate];
}



- (void)playBtnClickWith:(UIButton *)playBtn
{
    if (playBtn.selected) {
        
        [[ZQPlayerTool sharePlayerTool] pause];
        
    }else{
        
        ZQMusicModel *model = [[ZQMusicTool shareMusicTool] playingMusic];
        
        [[ZQPlayerTool sharePlayerTool] playMusicWithMusicName:model.mp3];
    }
    
}



- (void)listBtnClickWith:(UIButton *)listBtn
{
    
    
    
    
}


@end

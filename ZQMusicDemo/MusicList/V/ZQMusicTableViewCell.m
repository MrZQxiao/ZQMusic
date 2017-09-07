//
//  ZQMusicTableViewCell.m
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/4.
//  Copyright © 2017年 BTV. All rights reserved.
//

#define margin 15

#import "ZQMusicTableViewCell.h"
#import "ZQMusicModel.h"

@interface ZQMusicTableViewCell ()

@property (nonatomic,strong)UIImageView *iconImageView;


@property (nonatomic,strong)UILabel *singerLabel;

@property (nonatomic,strong)UIButton *accessBtn;


@end

@implementation ZQMusicTableViewCell



+ (instancetype)cellWithTable:(UITableView *)tableView
{
    static NSString *identifier = @"ZQMusicTableViewCell";
    ZQMusicTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[ZQMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}






- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
        
        
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        
        _singerLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_singerLabel];
        
         _accessBtn = [[UIButton alloc] init];
        [_accessBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [self.contentView addSubview:_accessBtn];
        [_accessBtn addTarget:self action:@selector(accessBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    _iconImageView.frame = CGRectMake(margin, margin, 50, 50);
    

    CGFloat nameLabelX = CGRectGetMaxX(_iconImageView.frame) + margin *0.5;
    CGFloat nameLabelY = margin;
    CGFloat nameLabelW = ScreenWidth - nameLabelX - margin;
    CGFloat nameLabelH = 20;
    _nameLabel.frame = CGRectMake(nameLabelX, nameLabelY , nameLabelW , nameLabelH);

    
    
    
    
    CGFloat singerLabelY = CGRectGetMaxY(_nameLabel.frame) + margin/2;
    _singerLabel.frame = CGRectMake(nameLabelX, singerLabelY, nameLabelW, nameLabelH);

    
    CGFloat accessBtnW = 20;
    CGFloat accessBtnH = 20;
    CGFloat accessBtnX = ScreenWidth - margin - accessBtnW;
    CGFloat accessBtnY = (80 - accessBtnH) * 0.5;
    _accessBtn.frame = CGRectMake(accessBtnX, accessBtnY, accessBtnW, accessBtnH);
    

    
}



- (void)setMusci:(ZQMusicModel *)musci
{
    _musci = musci;
    
    
    _iconImageView.image = [UIImage imageNamed:musci.image];
    
    _nameLabel.text = musci.name;
    _nameLabel.font = ZQFont(15);
    _nameLabel.textColor = BlackColor;
    
    _singerLabel.text = musci.singer;
    _singerLabel.font = ZQFont(15);
    _singerLabel.textColor = BlackColor;
    
    
}

- (void)accessBtnClick
{
    if ([self.delegate respondsToSelector:@selector(cellAccessViewClikWithMusic:)]) {
        [self.delegate cellAccessViewClikWithMusic:_musci];
    }
}


@end

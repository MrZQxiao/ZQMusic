//
//  ZQMusicListToolBar.h
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/4.
//  Copyright © 2017年 BTV. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZQMusicModel;



@interface ZQMusicListToolBar : UIView

@property (nonatomic,strong)ZQMusicModel *musicModel;

@property (nonatomic,strong)UIButton *palyBtn;

@property (nonatomic,strong)UIButton *listBtn;


- (void)stopAnimate;

- (void)resumeAnimate;

@end

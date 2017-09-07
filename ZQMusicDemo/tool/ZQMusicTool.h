//
//  ZQMusicTool.h
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/5.
//  Copyright © 2017年 BTV. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZQMusicModel;


@interface ZQMusicTool : NSObject

+(instancetype)shareMusicTool;

// 获取所有音乐
-(NSArray *)Musics;

// 当前正在播放的音乐
-(ZQMusicModel *)playingMusic;

// 设置默认播放的音乐
-(void)setUpPlayingMusic:(ZQMusicModel *)playingMusic;

// 返回上一首音乐
- (ZQMusicModel *)previousMusic;

// 返回下一首音乐
- (ZQMusicModel *)nextMusic;



@end

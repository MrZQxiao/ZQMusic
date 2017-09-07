//
//  ZQPlayerTool.h
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/5.
//  Copyright © 2017年 BTV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQPlayerTool : NSObject



+(instancetype)sharePlayerTool;
/// 播放
/// @param name 歌曲名称
-(void)playMusicWithMusicName:(NSString *)name;
/// 暂停
-(void)pause;
/// 歌曲总时长字符串
-(NSString *)durationMusicString;
/// 总时长
-(NSTimeInterval)durationMusic;
/// 当前播放时长
-(NSString *)currentTimeString;
/// 当前时长
-(NSTimeInterval)currentTime;
/// 进度
-(CGFloat)musicProgress;


/**
 是否正在播放
 */
- (BOOL)isplaying;


/**
 下一首
 */
- (void)nextMusic;


/**
 上一首
 */
- (void)previousMusic;




@end

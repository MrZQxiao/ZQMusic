//
//  ZQPlayerTool.m
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/5.
//  Copyright © 2017年 BTV. All rights reserved.
//

#import "ZQPlayerTool.h"
#import <AVFoundation/AVFoundation.h>
#import "ZQMusicTool.h"
#import "ZQMusicModel.h"

@interface ZQPlayerTool ()
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, copy) NSString *currentName;
@property (nonatomic, assign) CGFloat musicProgre;

@end

@implementation ZQPlayerTool


// 单例
+(instancetype)sharePlayerTool {
    static ZQPlayerTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZQPlayerTool alloc]init];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    });
    return instance;
}
// 播放
-(void)playMusicWithMusicName:(NSString *)name {
    
    if (name == nil) {
        return;
    }
    
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:nil];
    
    if (path == nil) {
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    if (![self.currentName isEqualToString:name]) {
        
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"musicDidChange" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];

        
    }
    self.currentName = name;
    [self.player prepareToPlay];
    [self.player play];
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"audioDidPlay" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
// 暂停
-(void) pause {
    
    if (self.player.playing) {
        
        [self.player pause];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"audioDidStop" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];

    }
}
/// 总时长字符串
-(NSString *)durationMusicString {
    
    return [NSString stringWithFormat:@"%02d:%02d",(int)self.player.duration / 60, (int)self.player.duration % 60];
    
}
/// 总时长
-(NSTimeInterval)durationMusic {
    
    return self.player.duration;
}
/// 返回当前时长字符串
-(NSString *)currentTimeString {
    
    return [NSString stringWithFormat:@"%02d:%02d",(int)self.player.currentTime / 60, (int)self.player.currentTime % 60];
    
}
/// 返回当前时长
-(NSTimeInterval)currentTime {
    
    return self.player.currentTime;
    
}

/// 当前进度
-(CGFloat)musicProgress {
    
    return self.player.currentTime / self.player.duration;
}



- (void)nextMusic
{
    ZQMusicModel *model = [[ZQMusicTool shareMusicTool] nextMusic];
    [[ZQMusicTool shareMusicTool] setUpPlayingMusic:model];
    [self playMusicWithMusicName:model.mp3];
}


- (void)previousMusic
{
    ZQMusicModel *model = [[ZQMusicTool shareMusicTool] previousMusic];
    [[ZQMusicTool shareMusicTool] setUpPlayingMusic:model];
    [self playMusicWithMusicName:model.mp3];
}

- (BOOL)isplaying{
    return self.player.playing;
}

@end

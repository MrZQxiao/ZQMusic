//
//  ZQMusicTool.m
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/5.
//  Copyright © 2017年 BTV. All rights reserved.
//

#import "ZQMusicTool.h"
#import "ZQMusicModel.h"
#import <MJExtension.h>

@implementation ZQMusicTool



static NSArray *_musics;
static ZQMusicModel *_playingMusic;


// 单例
+(instancetype)shareMusicTool {
    static ZQMusicTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZQMusicTool alloc]init];
       
    });
    return instance;
}




// 类加载的时候初始化音乐列表和播放音乐
+(void)initialize
{
    if (_musics == nil) {
        _musics = [ZQMusicModel objectArrayWithFilename:@"mlist.plist"];
    }
    if (_playingMusic == nil) {
        _playingMusic = _musics[4];
    }
}
// 获取所有音乐
-(NSArray *)Musics
{
    return _musics;
}
// 当前正在播放的音乐
-(ZQMusicModel *)playingMusic
{
    return _playingMusic;
}
// 设置默认播放的音乐
-(void)setUpPlayingMusic:(ZQMusicModel *)playingMusic
{
    _playingMusic = playingMusic;
}

// 返回上一首音乐
- (ZQMusicModel *)previousMusic
{
    NSInteger index = [_musics indexOfObject:_playingMusic];
    
    
    if (index == 0) {
        index = _musics.count -1;
    }else{
        index = index -1;
    }
    ZQMusicModel *previousMusic = _musics[index];
    return previousMusic;
}

// 返回下一首音乐
- (ZQMusicModel *)nextMusic
{
    NSInteger index = [_musics indexOfObject:_playingMusic];
    if (index == _musics.count - 1) {
        index = 0;
    }else{
        index = index +1;
    }
    ZQMusicModel *previousMusic = _musics[index];
    return previousMusic;
}




@end

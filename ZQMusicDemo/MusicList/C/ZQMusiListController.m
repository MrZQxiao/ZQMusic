//
//  ZQMusiListController.m
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/4.
//  Copyright © 2017年 BTV. All rights reserved.
//

#import "ZQMusiListController.h"
#import "ZQMusicTool.h"
#import "ZQMusicModel.h"
#import "ZQMusicTableViewCell.h"
#import "ZQMusicListToolBar.h"
#import "ZQPlayerTool.h"
#import "ZQMusicShowView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PKRevealController.h"


@interface ZQMusiListController ()<UITableViewDelegate,UITableViewDataSource,ZQMusicTableViewCellDelegate>


/**
 列表
 */
@property (nonatomic,strong)UITableView *tabelView;


/**
 底部工具栏
 */
@property (nonatomic,strong)ZQMusicListToolBar *toolBar;


/**
 当前播放索引
 */
@property (nonatomic,strong)NSIndexPath *currentSelect;


/**
 所有歌曲
 */
@property (nonatomic,strong)NSArray *musics;


/**
 定时器
 */
@property (nonatomic,strong)NSTimer *timer;




@end

@implementation ZQMusiListController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioDidPlay) name:@"audioDidPlay" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioDidStop) name:@"audioDidStop" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicDidChange) name:@"musicDidChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    



    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"播放列表";
    
    _currentSelect = [NSIndexPath indexPathForRow:0 inSection:0];
    [[ZQMusicTool shareMusicTool] setUpPlayingMusic:self.musics[0]];

    [self buildLeftItem];
    [self buildTableView];
    [self buildToolBar];
    
    // 锁屏
    [[UIApplication sharedApplication] becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
}


- (NSArray *)musics
{
    if (_musics == nil) {
        _musics = [[ZQMusicTool shareMusicTool] Musics];
    }
    return _musics;
}




-(BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark --初始化UI
- (void)buildLeftItem
{
    UIBarButtonItem *leftItem = [UIBarButtonItem barButtonItemWithImage:@"menu" target:self selector:@selector(menuBtnClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (void)buildTableView
{
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth , ScreenHeight - 114)];
    
    [self.view addSubview:_tabelView];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)buildToolBar
{
    ZQMusicListToolBar *ToolBar = [[ZQMusicListToolBar alloc] initWithFrame:CGRectMake(0, ScreenHeight - 114, ScreenWidth, 50)];
    ToolBar.backgroundColor = GrayColor;
    ToolBar.musicModel = [[ZQMusicTool shareMusicTool] playingMusic];
    self.toolBar = ToolBar;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buildPlayView)];
    
    [self.toolBar addGestureRecognizer:tap];
    
    [self.view addSubview:ToolBar];
    
}

#pragma mark --播放页弹出
- (void)buildPlayView
{
    ZQMusicShowView *PlayView = [ZQMusicShowView instanceMusicShowView];
    
    PlayView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:PlayView];

}

#pragma mark --tableView数据源代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQMusicTableViewCell *cell = [ZQMusicTableViewCell cellWithTable:tableView];
    
    ZQMusicModel *music = _musics[indexPath.row];
    
    ZQMusicModel *currentMusic = [[ZQMusicTool shareMusicTool] playingMusic];
    
    cell.musci = music;
    
    
    if ([music.name isEqualToString:currentMusic.name]) {
        cell.nameLabel.textColor = [UIColor redColor];
        
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQMusicModel *model = self.musics[indexPath.row];
    self.toolBar.musicModel = model;
    [[ZQMusicTool shareMusicTool] setUpPlayingMusic:model];
    [[ZQPlayerTool sharePlayerTool] playMusicWithMusicName:model.mp3];
    _currentSelect = indexPath;
    [self buildPlayView];
    
}


- (void)cellAccessViewClikWithMusic:(ZQMusicModel *)music
{
    DebugLog(@"更多选项");
}

#pragma mark --菜单栏滑出/隐藏
- (void)menuBtnClick
{
    [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
}


#pragma mark --锁屏界面 显示歌曲基本信息
-(void)updateScreenMusicInfo {
    
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    ZQMusicModel *music = [[ZQMusicTool shareMusicTool] playingMusic];
    
    //初始化   给他 专辑图片  播放时间进度
    //歌手名称
    dict[MPMediaItemPropertyAlbumTitle]= music.zhuanji;
    dict[MPMediaItemPropertyArtist]= music.singer;
    dict[MPMediaItemPropertyTitle]= music.name;
    //设置当前时间
    dict[MPNowPlayingInfoPropertyElapsedPlaybackTime]=@([[ZQPlayerTool sharePlayerTool] currentTime]);
    
    //总时间
    dict[MPMediaItemPropertyPlaybackDuration]= @([[ZQPlayerTool sharePlayerTool] durationMusic]);
    
    // 开启上下文
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.width - 20);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    
    UIImage *sourceImage = [UIImage imageNamed:music.image];
    
    [sourceImage drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    dict[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc]initWithImage:newImage];
    
    infoCenter.nowPlayingInfo = dict;
}


#pragma mark -- 响应锁屏点击
-(void)remoteControlReceivedWithEvent:(UIEvent *)event {
    
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        {
            ZQMusicModel *music = [[ZQMusicTool shareMusicTool] playingMusic];
            [[ZQPlayerTool sharePlayerTool] playMusicWithMusicName:music.mp3];

        }
            break;
        case UIEventSubtypeRemoteControlPause:
            [[ZQPlayerTool sharePlayerTool] pause];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
        {
            ZQMusicModel *model = [[ZQMusicTool shareMusicTool] previousMusic];
            [[ZQMusicTool shareMusicTool] setUpPlayingMusic:model];
            [[ZQPlayerTool sharePlayerTool] playMusicWithMusicName:model.mp3];
        }
            break;
        case UIEventSubtypeRemoteControlNextTrack:
        {

            [[ZQPlayerTool sharePlayerTool] nextMusic];

        }
            break;
            
        default:
            break;
    }
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    
    [[ZQPlayerTool sharePlayerTool] nextMusic];
}


#pragma mark --通知监听

- (void)audioDidPlay
{
    DebugLog(@"播放");
    
    
    [self.toolBar resumeAnimate];
    
    self.toolBar.palyBtn.selected = YES;
}




- (void)audioDidStop
{
    [self.toolBar stopAnimate];
    self.toolBar.palyBtn.selected = NO;
    DebugLog(@"暂停");
}


- (void)musicDidChange
{
    self.toolBar.musicModel = [[ZQMusicTool shareMusicTool] playingMusic];
    
    [self.tabelView reloadData];
}


- (void)applicationEnterBackground
{
    if ([[ZQPlayerTool sharePlayerTool] isplaying]) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0 target:self selector:@selector(updateScreenMusicInfo) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

    }
}


- (void)applicationBecomeActive
{
    [self.timer invalidate];
    self.timer = nil;

}






- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

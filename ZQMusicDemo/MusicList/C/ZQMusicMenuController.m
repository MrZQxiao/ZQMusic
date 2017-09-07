//
//  ZQMusicMenuController.m
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/7.
//  Copyright © 2017年 BTV. All rights reserved.
//

#import "ZQMusicMenuController.h"
#import "ZQMusiListController.h"
#import "PKRevealController.h"


@interface ZQMusicMenuController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) ZQMusiListController *mainFaceController;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic,strong)NSArray *setArray;




@end

@implementation ZQMusicMenuController

@synthesize mainFaceController = _mainFaceController;


- (ZQMusiListController *) mainFaceController
{
    if(!_mainFaceController)
    {
        _mainFaceController = [[ZQMusiListController alloc] init];
    }
    return _mainFaceController;
}



- (NSArray *)setArray
{
    if (_setArray == nil) {
        _setArray = @[@"仅Wi-Fi联网",@"定时关闭",@"免流量服务",@"微音云音乐网盘",@"传歌到手机",@"QPlay与车载音乐",@"清理占用空间",@"帮助与反馈",@"关于QQ音乐"];
    }
    
    return _setArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.setArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *set =self.setArray[indexPath.row];
    
    if ([set isEqualToString:@"仅Wi-Fi联网"]||[set isEqualToString:@"定时关闭"]) {
        
        cell.accessoryView = [[UISwitch alloc] init];
    }

    
    cell.textLabel.text = set;
    

    return cell;
}





@end

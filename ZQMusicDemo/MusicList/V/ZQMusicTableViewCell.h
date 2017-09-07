//
//  ZQMusicTableViewCell.h
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/4.
//  Copyright © 2017年 BTV. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZQMusicModel;

@protocol ZQMusicTableViewCellDelegate <NSObject>

- (void)cellAccessViewClikWithMusic:(ZQMusicModel *)music;

@end

@interface ZQMusicTableViewCell : UITableViewCell

+ (instancetype)cellWithTable:(UITableView *)tableView;

@property (nonatomic,strong)ZQMusicModel *musci;

@property (nonatomic,strong)UILabel *nameLabel;


@property (nonatomic,weak)id<ZQMusicTableViewCellDelegate> delegate;

@end

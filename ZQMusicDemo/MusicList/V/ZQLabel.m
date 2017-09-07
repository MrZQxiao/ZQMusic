//
//  ZQLabel.m
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/7.
//  Copyright © 2017年 BTV. All rights reserved.
//

#import "ZQLabel.h"

@implementation ZQLabel

-(void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [[UIColor greenColor] setFill];
    UIRectFillUsingBlendMode(CGRectMake(0, 0, _progress * rect.size.width, rect.size.height), kCGBlendModeSourceIn);
}



@end

//
//  ZQLyricTool.m
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/5.
//  Copyright © 2017年 BTV. All rights reserved.
//

#import "ZQLyricTool.h"
#import "ZQLrcModel.h"

@implementation ZQLyricTool


+(NSArray *)lyricListWithName:(NSString *)name {
    
    NSMutableArray *resArray = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:nil];
    
    NSString *originString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *lines = [originString componentsSeparatedByString:@"\n"];
    
    
    
    for (NSString *line in lines) {
        // 正则表达式
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"\\[[0-9][0-9]:[0-9][0-9]\\.[0-9][0-9]\\]" options:0 error:nil];
        NSArray *arr = [regular matchesInString:line options:NSMatchingReportCompletion range:NSMakeRange(0, line.length)];
        // 正文
        NSTextCheckingResult *lastResult = [arr lastObject];
        
        NSString *strText = [line substringFromIndex: lastResult.range.location + lastResult.range.length ];
        
        for (NSTextCheckingResult *result in arr) {
            // 时间文本
            NSString *strTimer = [line substringWithRange:result.range];
            

            // 创建模型
            ZQLrcModel *model = [[ZQLrcModel alloc]init];
            
            model.text = strText;

            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"[mm:ss.SS]";
            NSDate *dateModel =  [formatter dateFromString:strTimer];
            
            NSDate *dateZero =  [formatter dateFromString:@"[00:00.00]"];
            model.time = [dateModel timeIntervalSinceDate:dateZero];
            
            [resArray addObject:model];
            
        }
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    return [resArray sortedArrayUsingDescriptors:@[sort]];
    
}




@end

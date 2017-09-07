//
//  ZQNavigationController.m
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/4.
//  Copyright © 2017年 BTV. All rights reserved.
//

#import "ZQNavigationController.h"

@interface ZQNavigationController ()

@end

@implementation ZQNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize
{
    [self setupNavigationBarTheme];
}

+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    [appearance setBackgroundImage:[UIImage createImageWithColor:NavColor]
                    forBarPosition:UIBarPositionAny
                        barMetrics:UIBarMetricsDefault];
    [appearance setShadowImage:[UIImage new]];
    
    appearance.translucent = NO;
    // 导航栏标题字体颜色
    [appearance setTitleTextAttributes:@{NSFontAttributeName:ZQFont(18),NSForegroundColorAttributeName:[UIColor whiteColor]}];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"Return" target:self selector:@selector(ReturnToPreviousPage)];
        
    }
    
    
    [super pushViewController:viewController animated:animated];
    
}

- (void)ReturnToPreviousPage
{
    [self popViewControllerAnimated:YES];
    
}

- (void)BackToHomePage
{
    [self popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

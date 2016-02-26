//
//  ZMSTabBarController.m
//  MuZhiSou
//
//  Created by MCJ on 16/1/21.
//  Copyright (c) 2016年 MuZhiSou. All rights reserved.
//

#import "ZMSTabBarController.h"
#import "SearchViewController.h"
#import "RQViewController.h"
#import "JokerViewController.h"
#import "IntroduceView.h"

@interface ZMSTabBarController ()

@end

@implementation ZMSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建视图
    [self creatViewControllers];
    
    // 引导页
    [self introduceWithView];
}

- (void)creatViewControllers
{
    // 实例化模块视图
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    RQViewController *rqVC = [[RQViewController alloc] init];
    JokerViewController *jokerVC = [[JokerViewController alloc] init];
    
    // 给模块视图包装一层UINavgation
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    UINavigationController *rqNav = [[UINavigationController alloc] initWithRootViewController:rqVC];
    UINavigationController *jokerNav = [[UINavigationController alloc] initWithRootViewController:jokerVC];
    
    // 把视图模块添加到UITabBar上
    self.viewControllers = @[searchNav,rqNav,jokerNav];
    
    // 设置模块图片
    UITabBarItem *imItem = [[UITabBarItem alloc]initWithTitle:@"搜索" image:[UIImage imageNamed:@"tab_btn1_nor.png"] selectedImage:[UIImage imageNamed:@"tab_btn1_sel.png"]];
    searchNav.tabBarItem = imItem;
    UITabBarItem *bbsItem = [[UITabBarItem alloc]initWithTitle:@"二维码" image:[UIImage imageNamed:@"tab_btn2_nor.png"] selectedImage:[UIImage imageNamed:@"tab_btn2_sel.png"]];
    rqNav.tabBarItem = bbsItem;
    UITabBarItem *dcItem = [[UITabBarItem alloc]initWithTitle:@"笑话" image:[UIImage imageNamed:@"tab_btn3_nor.png"] selectedImage:[UIImage imageNamed:@"tab_btn3_sel.png"]];
    jokerNav.tabBarItem = dcItem;

}

- (void)introduceWithView
{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLogin"] isEqualToString:@"YES"]) {
        IntroduceView *introView = [[IntroduceView alloc] init];
        [self.view addSubview:introView];
    }
}
@end

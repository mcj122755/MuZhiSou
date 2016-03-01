//
//  RootViewController.m
//  MuZhiSou
//
//  Created by MUCHUANJIAN on 16/2/29.
//  Copyright © 2016年 MuZhiSou. All rights reserved.
//

#import "RootViewController.h"
#import "IntroduceView.h"
#import "DisperseBtn.h"
#import "SearchViewController.h"
#import "RQViewController.h"
#import "CustomViewController.h"

@interface RootViewController ()
{
    DisperseBtn *_disperseBtn;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    // 0. 添加引导页
    [self addIntroduceView];
    
    // 1. 添加背景图
    [self addBackGroungImage];
    
    // 2. 添加显示的功能
    [self addToolsButtons];
}


- (void)addIntroduceView
{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLogin"] isEqualToString:@"YES"]) {
        IntroduceView *introView = [[IntroduceView alloc] init];
        [self.view addSubview:introView];
    }
}

- (void)addBackGroungImage
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"back.jpg"];
    [self.view addSubview:imageView];
    
}

- (void)addToolsButtons
{
    CGFloat btnW = 100;
    CGFloat btnH = 100;
    CGFloat btnX = 0;
    CGFloat btnY = (self.view.frame.size.height - btnH)/2 ;
    _disperseBtn = [[DisperseBtn alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    _disperseBtn.borderRect = self.view.frame;
    _disperseBtn.closeImage = [UIImage imageNamed:@"zhimu"];
    _disperseBtn.openImage =  [UIImage imageNamed:@"zhimu"];
    [self.view addSubview:_disperseBtn];
    
    // 设置按钮个数
    [self setDisViewButtonsNum:3];
    
    [self performSelector:@selector(startTap) withObject:nil afterDelay:0.7];
}

- (void)startTap{
    [_disperseBtn firstTap];
}

- (void)setDisViewButtonsNum:(int)num{
    
    [_disperseBtn recoverBotton];
    
    for (UIView *btn in _disperseBtn.btns) {
        [btn removeFromSuperview];
    }
    
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i< num; i++) {
        UIButton *btn = [UIButton new];
        NSString *name = [NSString stringWithFormat:@"icon_%d",i+ 1];
        [btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [marr addObject:btn];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(buttonTagget:) forControlEvents:UIControlEventTouchUpInside];
    }
    _disperseBtn.btns = [marr copy];
}

- (void)buttonTagget:(UIButton *)sender
{
    if (sender.tag == 101) {
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:searchVC];
        [self presentViewController:navC animated:YES completion:nil];
    }else if (sender.tag == 102){
     
        CustomViewController *customVC = [[CustomViewController alloc] initWithIsQRCode:YES Block:^(NSString *str, BOOL isOK) {
            
        }];
        customVC.view.backgroundColor = [UIColor whiteColor];
        
        [self presentViewController:customVC animated:YES completion:nil];
    }
}
@end

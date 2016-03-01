//
//  RQViewController.m
//  MuZhiSou
//
//  Created by MCJ on 16/1/21.
//  Copyright (c) 2016年 MuZhiSou. All rights reserved.
//

#import "RQViewController.h"
#import "CustomViewController.h"

@interface RQViewController ()

@end

@implementation RQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 1. 添加二维码扫描
    [self addRQButton];
    
    // 2. 添加分享
    [self addShareButton];
    
}

- (void)addRQButton
{
    
    UIButton *qrButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 50)];
    [qrButton setBackgroundColor:[UIColor lightGrayColor]];
    [qrButton setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [qrButton addTarget:self action:@selector(clickQrButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qrButton];
    
}

- (void)addShareButton
{
    UIButton *qrButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 50)];
    [qrButton setBackgroundColor:[UIColor lightGrayColor]];
    [qrButton setTitle:@"分享给朋友" forState:UIControlStateNormal];
    [qrButton addTarget:self action:@selector(clickQrButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qrButton];
}

- (void)clickQrButton
{
    
    CustomViewController *customVC = [[CustomViewController alloc] initWithIsQRCode:YES Block:^(NSString *str, BOOL isOK) {
        
    }];
    customVC.view.backgroundColor = [UIColor whiteColor];
    
    [self presentViewController:customVC animated:YES completion:nil];
}

@end

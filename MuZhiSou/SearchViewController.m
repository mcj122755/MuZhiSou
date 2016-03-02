//
//  SearchViewController.m
//  MuZhiSou
//
//  Created by MCJ on 16/1/21.
//  Copyright (c) 2016年 MuZhiSou. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
{
    UIWebView *_webView;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拇指搜";

    // 添加退出和刷新按钮
    [self addLeftAndRightItem];
    
    // 添加webView
    [self addWebViewToView];
    
    // 添加后退按钮
    [self addBackButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)addWebViewToView
{
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    NSURL*url = [NSURL URLWithString:@"http://wap.muzhiso.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)addLeftAndRightItem
{
    
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(clickLeftButton)];
    self.navigationItem.leftBarButtonItem = stopButton;
    
    UIBarButtonItem *rightButtonLtem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton)];
    self.navigationItem.rightBarButtonItem = rightButtonLtem;
}

- (void)addBackButton
{
    CGFloat backBtnW = 30;
    CGFloat backBtnH = 30;
    CGFloat backBtnX = 10;
    CGFloat backBtnY = self.view.bounds.size.height - backBtnH - 80;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(backBtnX, backBtnY, backBtnW, backBtnH)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)clickLeftButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickRightButton
{
    [_webView reload];
}

- (void)clickBackButton
{
    [_webView goBack];
}
@end

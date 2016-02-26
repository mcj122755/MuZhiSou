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
    self.title = @"指拇搜索";

    // 添加返回和刷新按钮
    [self addLeftAndRightItem];
    
    // 添加webView
    [self addWebViewToView];
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
    UIBarButtonItem *leftButtonLtem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftButton)];
    self.navigationItem.leftBarButtonItem = leftButtonLtem;
    
    UIBarButtonItem *rightButtonLtem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton)];
    self.navigationItem.rightBarButtonItem = rightButtonLtem;
}


- (void)clickLeftButton
{
    [_webView goBack];
}

- (void)clickRightButton
{
    [_webView reload];
}

@end

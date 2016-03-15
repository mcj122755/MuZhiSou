//
//  SearchViewController.m
//  MuZhiSou
//
//  Created by MCJ on 16/1/21.
//  Copyright (c) 2016年 MuZhiSou. All rights reserved.
//

#import "SearchViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "CustomViewController.h"
#import "UMSocial.h"
#import "IntroduceView.h"

@interface SearchViewController ()<NJKWebViewProgressDelegate,UIWebViewDelegate>
{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
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

- (void)addIntroduceView
{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLogin"] isEqualToString:@"YES"]) {
        IntroduceView *introView = [[IntroduceView alloc] init];
        [self.view addSubview:introView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [_progressView removeFromSuperview];

}

- (void)addWebViewToView
{
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    NSURL*url = [NSURL URLWithString:@"http://wap.muzhiso.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)addLeftAndRightItem
{
    
//    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(clickLeftButton)];
//    self.navigationItem.leftBarButtonItem = stopButton;
//    
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithTitle:@"工具" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftButton)];
     self.navigationItem.leftBarButtonItem = stopButton;
    
    UIBarButtonItem *rightButtonLtem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton)];
    self.navigationItem.rightBarButtonItem = rightButtonLtem;
}

- (void)addBackButton
{
    CGFloat backBtnW = 30;
    CGFloat backBtnH = 30;
    CGFloat backBtnX = 10;
    CGFloat backBtnY = self.view.bounds.size.height - backBtnH - 100;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(backBtnX, backBtnY, backBtnW, backBtnH)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}



- (void)clickLeftButton
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"扫描二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CustomViewController *customVC = [[CustomViewController alloc] initWithIsQRCode:YES Block:^(NSString *str, BOOL isOK) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str]]];
        }];
        customVC.view.backgroundColor = [UIColor whiteColor];
        
        [self presentViewController:customVC animated:YES completion:nil];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"分享给朋友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"53290df956240b6b4a0084b3" shareText:@"最好用的搜索-拇指搜" shareImage:[UIImage imageNamed:@"icon.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToTencent,UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToWechatTimeline,UMShareToWechatSession, nil] delegate:nil];
        
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)clickRightButton
{
    [_webView reload];
}

- (void)clickBackButton
{
    [_webView goBack];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}
@end

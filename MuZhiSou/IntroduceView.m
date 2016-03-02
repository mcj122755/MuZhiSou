//
//  IntroduceView.m
//  MCJRescom
//
//  Created by MCJ on 15/12/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_SCALE [UIScreen mainScreen].bounds.size.width/320  //屏幕适配比例

#import "IntroduceView.h"

@interface IntroduceView ()<UIScrollViewDelegate>
@property (strong, nonatomic)UIPageControl *page;
@property (strong, nonatomic)NSArray *introduceArray;
@end

@implementation IntroduceView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 1. 引导图片
        _introduceArray = [[NSArray alloc] initWithObjects:@"intro_1.jpg",@"intro_2.jpg", @"intro_3.jpg",nil];
        
        // 属性
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor whiteColor];
        
        // 添加引导控件
        [self pictureScrollViewAdd];
        [self pageControlAdd];
    }
    return self;
}

- (void)pictureScrollViewAdd
{
    //滑动展示图片控件
    UIScrollView *pictureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    pictureScrollView.pagingEnabled = YES;
    pictureScrollView.bounces = NO;
    pictureScrollView.backgroundColor = [UIColor clearColor];
    pictureScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*[_introduceArray count], SCREEN_WIDTH);
    pictureScrollView.delegate = self;
    pictureScrollView.tag = 1001;
    pictureScrollView.showsHorizontalScrollIndicator = NO;
    pictureScrollView.showsVerticalScrollIndicator = NO;
    for (int i=0; i<[_introduceArray count]; i++) {
        UIImageView *picture = [[UIImageView alloc] init];
        picture.image = [UIImage imageNamed:[_introduceArray objectAtIndex:i]];
        picture.contentMode = UIViewContentModeScaleAspectFill;
        picture.layer.masksToBounds = YES;
        picture.userInteractionEnabled = YES;
        picture.frame =CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [pictureScrollView addSubview:picture];
        if (i==[_introduceArray count]-1) {
            UIButton *enterBut = [UIButton buttonWithType:UIButtonTypeCustom];
            enterBut.frame = CGRectMake((320-115)/2*SCREEN_SCALE, SCREEN_HEIGHT-90*SCREEN_SCALE, 115.0f*SCREEN_SCALE, 30*SCREEN_SCALE);
            if (SCREEN_HEIGHT<500) {
                enterBut.frame = CGRectMake((320-115)/2*SCREEN_SCALE, SCREEN_HEIGHT-75*SCREEN_SCALE, 115.0f*SCREEN_SCALE, 30*SCREEN_SCALE);
                
            }
//            [enterBut setBackgroundImage:[UIImage imageNamed:@"btn_start"] forState:UIControlStateNormal];
            enterBut.titleLabel.font = [UIFont systemFontOfSize:20];
           [enterBut setTitle:NSLocalizedString(@"立即体验", nil) forState:UIControlStateNormal];
            //            [enterBut setTitle:NSLocalizedString(@"立即体验", nil) forState:UIControlStateHighlighted];
            [enterBut addTarget:self action:@selector(removeIntroduceView) forControlEvents:UIControlEventTouchUpInside];
            [picture addSubview:enterBut];
        }
    }
    [self addSubview:pictureScrollView];
}


- (void)pageControlAdd
{
    //定义PageControll
    _page = [[UIPageControl alloc] initWithFrame:CGRectMake((320-80)/2*SCREEN_SCALE, SCREEN_HEIGHT-45*SCREEN_SCALE, 80*SCREEN_SCALE, 20*SCREEN_SCALE)];
    if (SCREEN_HEIGHT<500) {
        _page.frame = CGRectMake((320-80)/2*SCREEN_SCALE, SCREEN_HEIGHT-35*SCREEN_SCALE, 80*SCREEN_SCALE, 20*SCREEN_SCALE);
    }
    _page.numberOfPages = [_introduceArray count];
    _page.currentPage = 0;
    _page.tag = 2222;
    [self addSubview:_page];
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 1001) {
        int pageNum = scrollView.contentOffset.x/SCREEN_WIDTH;
        _page.currentPage = pageNum;
    }
}

#pragma mark - 移除引导页
-(void)removeIntroduceView{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"firstLogin"];
    [UIView animateWithDuration:1.5 animations:^{
        self.alpha = 0;
        self.layer.transform = CATransform3DScale(self.layer.transform, 0.3, 0.3, 1.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
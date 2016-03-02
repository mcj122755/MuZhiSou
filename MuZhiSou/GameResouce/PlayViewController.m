//
//  PlayViewController.m
//  Game
//
//  Created by MUCHUANJIAN on 16/3/2.
//  Copyright © 2016年 MUCHUANJIAN. All rights reserved.
//

#import "PlayViewController.h"
#import "GameScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    
    
    [arch finishDecoding];
    
    return scene;
}

@end


@interface PlayViewController ()
{
    AVAudioPlayer *_audioPlayer;
    BOOL _boo;
}
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    //Sprite Kit applies additional optimizations to improve rendering performance
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //return UIInterfaceOrientationMaskAllButUpsideDown;
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (IBAction)clickCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"123.mp3" withExtension:Nil];
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
     _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    
      //3.缓冲
       [_audioPlayer prepareToPlay];
  
      //4.播放
      [_audioPlayer play];
    
      _audioPlayer.numberOfLoops = -1;
    
    // 成为摇晃相应
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
   
    if (!_boo) {
        [_audioPlayer pause];
    }else{
        [_audioPlayer play];
    }
    _boo = !_boo;
    return;
}


@end

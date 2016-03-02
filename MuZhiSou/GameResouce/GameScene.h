//
//  GameScene.h
//  MonkeyJump
//

//  Copyright (c) 2015 suoyong. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "VolumeValue.h"
@import iAd;

@interface GameScene : SKScene<Shouldpromptcahngdelegate>

//@property(nonatomic,strong) SKSpriteNode *monkey;
@property (nonatomic,strong) ADBannerView *adView;

@end

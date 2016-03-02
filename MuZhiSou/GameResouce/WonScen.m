//
//  WonScen.m
//  MonkeyJump
//
//  Created by suoyong on 7/2/15.
//  Copyright (c) 2015 suoyong. All rights reserved.
//

extern int j;

#import "WonScen.h"
#import "GameScene.h"

#define BABY_NAME NSLocalizedStringFromTable(@"BABY_NAME",@"WonScen",@"this is baby name")

@implementation WonScen

-(id)initWithSize:(CGSize)size won:(BOOL)won
{
    if (self = [super initWithSize:size]) {
     
        if(won){
            SKSpriteNode *nodes =  [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"terminalBackground.jpg"] size:CGSizeMake(self.frame.size.width, self.frame.size.height)];
            nodes.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            
            
            [self addChild:nodes];
            
            [self addPropUpLine];
            
            [self addLabelOne];
            
           // message = @"CLEVER BABY";
        } else {
            SKSpriteNode *nodes =  [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"backgound2.jpg"] size:CGSizeMake(self.frame.size.width, self.frame.size.height)];
            nodes.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            
            [self addChild:nodes];
            
            SKSpriteNode *delete =[SKSpriteNode spriteNodeWithImageNamed:@"delete"];
            delete.position = CGPointMake(self.frame.size.width/3, self.frame.size.height * 2 /3);
            delete.zPosition = 2;
            [delete setScale:0];
            
            [self addChild:delete];
            //SKAction *fadeout = [SKAction fadeOutWithDuration:0.1];
            SKAction *act1 = [SKAction waitForDuration:2];
            ///SKAction *fadein = [SKAction fadeInWithDuration:0.1];
            //SKAction *seqence = [SKAction sequence:@[fadeout,act1,fadein]];
            [delete runAction:act1 completion:^{
                [delete setScale:1];
            }];
            
            switch (j) {
                case 1:
                {
                    SKSpriteNode *nodenegative = [SKSpriteNode spriteNodeWithImageNamed:@"nsz1"];
                    nodenegative.position = CGPointMake(self.frame.size.width/3, self.frame.size.height * 2 /3);
                    nodenegative.zPosition = 1;
                    [nodenegative setScale:2];
                    [self addChild:nodenegative];
                }
                    break;
                case 2:
                {
                    SKSpriteNode *nodenegative = [SKSpriteNode spriteNodeWithImageNamed:@"nsz2"];
                    nodenegative.position = CGPointMake(self.frame.size.width/3, self.frame.size.height * 2 /3);
                    nodenegative.zPosition = 1;
                    [nodenegative setScale:2];
                    [self addChild:nodenegative];
                }
                    break;
                case 3:
                {
                    SKSpriteNode *nodenegative = [SKSpriteNode spriteNodeWithImageNamed:@"nsz3"];
                    nodenegative.position = CGPointMake(self.frame.size.width/3, self.frame.size.height * 2 /3);
                    nodenegative.zPosition = 1;
                    [nodenegative setScale:2];
                    [self addChild:nodenegative];
                }
                    break;
                case 4:
                {
                    SKSpriteNode *nodenegative = [SKSpriteNode spriteNodeWithImageNamed:@"nsz4"];
                    nodenegative.position = CGPointMake(self.frame.size.width/3, self.frame.size.height * 2 /3);
                    nodenegative.zPosition = 1;
                    [nodenegative setScale:2];
                    [self addChild:nodenegative];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //SKScene *myScence = [myScence alloc] initWithS
    SKScene *myScene = [[GameScene alloc] initWithSize:self.frame.size];
    SKTransition *reveal = [SKTransition fadeWithDuration:1];
    [self.view presentScene:myScene transition:reveal];
}

-(void)addPropUpLine
{
    SKSpriteNode *line = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithHue:1 saturation:1 brightness:1 alpha:0] size:CGSizeMake(self.frame.size.width, 1)];
    line.anchorPoint = CGPointMake(0, 0);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        line.position = CGPointMake(0, self.frame.size.height /2 - 60);
    } else {
        line.position = CGPointMake(0, self.frame.size.height /2 - 100);
    }
    [self addChild:line];
    
    line.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:line.size];
    line.physicsBody.dynamic = NO;
    
}
/*
-(void)addHealth
{
    SKSpriteNode *health1 = [SKSpriteNode spriteNodeWithImageNamed:@"art1"];
    SKSpriteNode *health2 = [SKSpriteNode spriteNodeWithImageNamed:@"art2"];
    
    health1.position = CGPointMake(self.frame.size.width /6, self.frame.size.height + 100);
    health2.position = CGPointMake(self.frame.size.width *2 /6, self.frame.size.height + 100);
    
    health1.zPosition = 1;
    health1.zPosition = 2;
    
    [self addChild:health1];
    [self addChild:health2];
    
    health1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:health1.size];
    health2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:health2.size];
    
    
    
}
*/
-(void)addLabelOne
{
    SKLabelNode *labelOne = [SKLabelNode labelNodeWithFontNamed:@"Noteworthy"];
    labelOne.text = BABY_NAME;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        labelOne.fontSize = 32;
    } else {
        labelOne.fontSize = 50;
    }
    
    labelOne.fontColor = [SKColor orangeColor];
    labelOne.position = CGPointMake(self.frame.size.width /5 -10, self.frame.size.height + 100);
    labelOne.zPosition = 3;
    [self addChild:labelOne];
    
    labelOne.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:labelOne.frame.size];
    
}

// self.backgroundColor = [UIColor greenColor];
/*
 SKSpriteNode *nv = [SKSpriteNode spriteNodeWithImageNamed:@"dasenlin.jpg"];
 
 nv.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
 
 [self addChild:nv];
 */
//UIImage *image = [UIImage imageNamed:@"dasenlin.jpg"];
//self.backgroundColor = [UIColor colorWithPatternImage:image];
/*
SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"chalkduster"];
label.text = message;
label.fontSize = 40;
label.fontColor = [SKColor blackColor];
label.position = CGPointMake(self.size.width/2,self.size.height/2);
[self addChild:label];
 */
/*
 [self runAction:
 [SKAction sequence:@[
 [SKAction waitForDuration:3.0],
 [SKAction runBlock:^{
 SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
 SKScene *myScene = [[SKScene alloc] initWithSize:size];
 [self.view presentScene:myScene transition:reveal];
 }]]]];
 */

@end
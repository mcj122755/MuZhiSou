//
//  GameScene.m
//  MonkeyJump
//
//  Created by suoyong on 6/29/15.
//  Copyright (c) 2015 suoyong. All rights reserved.
//

int j;  //other achieve know about external variation.

#import "GameScene.h"
#import "WonScen.h"
@import iAd;



#define RUNMONKEY @"runMonkey"
#define NODEPOSITIONX CGRectGetMidX(self.frame)/3
#define NODEPOSITIONY 30

typedef NS_OPTIONS(uint32_t, CollisionCategory){  //掩码就用NS_OPTION
    CollisionCategoryPlayer    = 0x1 << 0,
    CollisionCategoryStar      = 0x1 << 1,
    CollisionCategoryPlatform  = 0x1 << 2,
    CollisioncategoryFaintedMonkey = 0x1 << 3,
    CollisionCategoryPositiveCharacter = 0x1 << 4,
    CollisionCategoryNegativeCahracter = 0x1 << 5,
};

@interface GameScene()<SKPhysicsContactDelegate,ADBannerViewDelegate>
{
    SKSpriteNode *_monkey;
    NSArray *_monkeyRunFrame;
   
    SKSpriteNode *_faintedMonkey;
    
    
    NSInteger groundHeigh;  //106
    NSInteger monkeyHeigh;  //168
     //globle variable
    
    BOOL onoff;
    BOOL touchonoff;
    BOOL notEnd;
    
    //decide whether the monkey need to go to school
    BOOL appearSchool;
    
    
    
}

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeIntervl;
@property (nonatomic) NSTimeInterval cloudTimeInterval;
@property (nonatomic) NSTimeInterval treeTimeInterval;
@property (nonatomic) NSTimeInterval montainTimeInterval;

@property (nonatomic,strong) SKNode *monkeyNode;
@property (nonatomic,strong) SKSpriteNode  *jump;
@property (nonatomic,strong) SKSpriteNode  *carrige;

@property (nonatomic,strong) VolumeValue *value;

@end

@implementation GameScene

static float scale = 0.4;
static int k = 0;
int doubleJump = 0;
float voicePair;

-(VolumeValue *)value
{
    if (!_value) {
        _value = [[VolumeValue alloc] init];
        
    }
    return _value;
}

-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        self.value.delegate = self;
        //ground move
        self.backgroundColor  = [UIColor colorWithRed:0 green:10 blue:60 alpha:1];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(runGround) onTarget:self],[SKAction waitForDuration:7.9f]]]] withKey:@"runGroundAction"];
        
        //[self propup];
        [self runGround0];
        NSLog(@"%f",self.carrige.size.height);
        
        //[self addPropup];
        [self.monkeyNode addChild:_monkey];
        [self addChild:self.monkeyNode];
        //[_monkeyNode setScale:0.4];  //prior to rendering
        //以上属性我也不知道把他self。monkeNOde加在外边怎么了。就是不行。有时候改改顺序就能通过
        [_monkey setScale:0.4];

        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0.0, -2.0);
        
        notEnd = YES;
        scale = 0.4;
        k = 0;
        
        //2015-10-19加个广告：
        _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.scene.frame.size.height - 50, self.scene.frame.size.width, 50)];
        [self.view addSubview:self.adView];
        self.adView.delegate = self;
    }
    return self;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    //BOOL shouldExecuteAction = [se]
    return YES;
}



#pragma mark - touch!
/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   // NSLog(@"%f",_monkey.size.height);
    
    //if (_monkeyNode.position.y < 121 && touchonoff) {
    if ((touchonoff  && notEnd) || doubleJump == 1) {
        
        if (doubleJump == 0) {
            [_monkey removeFromParent];
            //self.jump = [SKSpriteNode spriteNodeWithImageNamed:@"monkey_jump"];
            [_monkeyNode addChild:self.jump];
            [_monkeyNode.physicsBody applyImpulse:CGVectorMake(0.0f, 130.0f)];
        }
        doubleJump++;
        onoff = YES;//检测每个帧position.y位置的开关，提高cpu效率。
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [_monkeyNode.physicsBody applyImpulse:CGVectorMake(0.0f, 140.0f)];
        } else {
            [_monkeyNode.physicsBody applyImpulse:CGVectorMake(0.0f, 240.0f)];
        }
        
        
        //below is Monkey node ,it's nothing about _jump and _monkey sprite
        //_monkeyNode.physicsBody.dynamic = YES;
        
        touchonoff = NO; //check multiple touch
  
     }
  
}
*/
-(SKSpriteNode *)jump
{
    if (!_jump) {
        _jump = [SKSpriteNode spriteNodeWithImageNamed:@"monkey_jump"];
        //_jump.anchorPoint = CGPointMake(0, 0);
        //_jump.position = CGPointMake(-_jump.size.width/2 , -_jump.size.height/2);
        [_jump setScale:0.4];
    }
    return _jump;
}

#pragma mark - update


-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast{
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 2) {
        self.lastSpawnTimeInterval = 0;
        if (!appearSchool) {
            int var = arc4random()%27;
            if (var == 0) {
                [self addNegativeCharacter];
            } else {
                [self addPositiveCharacter];
            }
        }
        
        
    
    }
    
}
-(void)updateCloud:(CFTimeInterval)cloudtime
{
    self.cloudTimeInterval += cloudtime;
    if (self.cloudTimeInterval > 3) {
        self.cloudTimeInterval = 0;
        [self addCloud];
    }
}
-(void)updateTree:(CFTimeInterval)treetime
{
    self.treeTimeInterval += treetime;
    if (self.treeTimeInterval > 8) {
        self.treeTimeInterval = 0;
        [self addTree];
    }
}
-(void)updateMontain:(CFTimeInterval)Montaintime
{
    self.montainTimeInterval += Montaintime;
    if (self.montainTimeInterval > 6) {
        self.montainTimeInterval = 0;
        [self addMountain];
    }
}

-(void)displayVale
{
    voicePair = self.value.voiceValue;
    //NSLog(@"%f",voicePair);
}

-(void)update:(NSTimeInterval)currentTime
{
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeIntervl;
    self.lastUpdateTimeIntervl = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    [self updateCloud:timeSinceLast];
    [self updateMontain:timeSinceLast];
    [self updateTree:timeSinceLast];
    
    if (_monkeyNode.physicsBody.velocity.dy == 0) {  //only for multi-touch
        touchonoff = YES;
        doubleJump = 0;  //double jump implentation
    }
    
    if (_monkeyNode.physicsBody.velocity.dy == 0 && onoff == YES) {
        [_monkeyNode removeAllChildren];
    
        [_monkeyNode addChild:_monkey];
        onoff = NO;
       
    }
    
    if (voicePair > -20) {   //it's jump so hight therefore two frame can't separete voice value.
    //if (_monkeyNode.position.y < 121 && touchonoff) {
    if ((touchonoff  && notEnd) || doubleJump == 1) {
        
        if (doubleJump == 0) {
            [_monkey removeFromParent];
            //self.jump = [SKSpriteNode spriteNodeWithImageNamed:@"monkey_jump"];
            [_monkeyNode addChild:self.jump];
            [_monkeyNode.physicsBody applyImpulse:CGVectorMake(0.0f, 100.0f)];
        }
        doubleJump++;
        onoff = YES;//检测每个帧position.y位置的开关，提高cpu效率。
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [_monkeyNode.physicsBody applyImpulse:CGVectorMake(0.0f, 130.0f)];
        } else {
            [_monkeyNode.physicsBody applyImpulse:CGVectorMake(0.0f, 230.0f)];
        }
        
        
        //below is Monkey node ,it's nothing about _jump and _monkey sprite
        //_monkeyNode.physicsBody.dynamic = YES;
        
        touchonoff = NO; //check multiple touch
        
        }
    }

}



-(void)didBeginContact:(SKPhysicsContact *)contact
{
    
   // [self faintedMonkey];
    //SKNode *other = (contact.bodyA.node != _monkeyNode) ? contact.bodyA.node : contact.bodyB.node;
    
    int bit = contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask;
    //NSLog(@"%d",contact.bodyA.categoryBitMask);  //this is monkey;
    //NSLog(@"%d",contact.bodyB.categoryBitMask);
  
    if (bit == 17) {
    SKAction *actionTouch = [SKAction scaleBy:1.1 duration:0.3];
    [_jump runAction:actionTouch ];
    // scale = 0.4;
    scale = scale * 1.1;
        
    //static int k = 0;
    //NSLog(@"static scale = %f, static k = %d",scale,k);
        
    switch (k) {
        case 0:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 45) duration:0.1];
            [_carrige runAction:ac];
            //NSLog(@"s111111");
        }
            break;
        case 1:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 48) duration:0.1];
            [_carrige runAction:ac];
             //NSLog(@"s111112");
        }
            break;
        case 2:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 52) duration:0.1];
            [_carrige runAction:ac];
             //NSLog(@"s111113");
        }
            break;
        case 3:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 55) duration:0.1];
            [_carrige runAction:ac];
        }
            break;
        case 4:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 59) duration:0.1];
            [_carrige runAction:ac];
        }
            break;
        case 5:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 63) duration:0.1];
            [_carrige runAction:ac];
        }
            break;
        case 6:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 68) duration:0.1];
            [_carrige runAction:ac];
        }
            break;
        case 7:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 73) duration:0.1];
            [_carrige runAction:ac];
        }
            break;
        case 8:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 79) duration:0.1];
            [_carrige runAction:ac];
        }
            break;
        case 9:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 85) duration:0.1];
            [_carrige runAction:ac];
        }
            break;
        case 10:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 92) duration:0.1];
            [_carrige runAction:ac];
        }
            break;
        case 11:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 100) duration:0.1];
            [_carrige runAction:ac];
        }
            break;
        case 12:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 109) duration:0.1];
            [_carrige runAction:ac];
        }
            break;
        case 13:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 118) duration:0.1];
            [_carrige runAction:ac];
        }
            break;
        case 14:
        {
            SKAction *ac = [SKAction moveTo:CGPointMake(0, 130) duration:0.1];
            [_carrige runAction:ac];
        }
            break;
            
        default:
            break;
    }
    k++;
    [_monkey setScale:scale];
        
    if (_monkey.frame.size.height > 230) {
        appearSchool = YES;
        [self removeActionForKey:@"positiveObject"];
        [self removeActionForKey:@"negativeObject"];
       // [_jump removeFromParent];
        SKAction *monkeyGotoSchool = [SKAction moveToX:self.frame.size.width  duration:3];
        SKAction *removeMonkey = [SKAction removeFromParent];
        
        
        SKAction * wonAction = [SKAction runBlock:^{
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:1];
            WonScen * gameOverScene = [[WonScen alloc] initWithSize:self.frame.size won:YES];
            [self.view presentScene:gameOverScene transition:reveal];
        }];
        
        SKAction *seq =[SKAction sequence:@[monkeyGotoSchool,wonAction,removeMonkey]];
        [_monkey runAction:seq completion:^{
       

        }];
   
        notEnd = NO;
    
        
    }
        

        [self fruitRemove:(SKSpriteNode *)contact.bodyB.node];
    
    
    } else
    {
        [self faintedMonkeyfun];
        [_jump removeFromParent];
        scale = 0.4; k = 0;

        [_monkey removeFromParent];
        
        SKAction *loseAction = [SKAction runBlock:^{
            SKTransition *appear = [SKTransition moveInWithDirection:SKTransitionDirectionRight duration:2];
            WonScen * gameLose = [[WonScen alloc] initWithSize:self.frame.size won:NO];
            [self.view presentScene:gameLose transition:appear];
             [_monkey setScale:0.4];
        }];
        
        
        [_monkeyNode runAction:loseAction ];
            
        
    }

}


-(void)fruitRemove:(SKNode *)fruit
{
    [fruit removeFromParent];
}



#pragma mark - ground and prop up


-(SKSpriteNode *)carrige
{
    //SKNode *carriage = [SKNode node];
    
    if (!_carrige) {
        //static int j = 45;
    _carrige = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0] size: CGSizeMake(self.frame.size.width, 1)];
    _carrige.anchorPoint = CGPointMake(0, 0);
    _carrige.position = CGPointMake(0, 41);
    _carrige.zPosition = 10;
    //[_carrige setScale:1.6];
    [self addChild:_carrige];
    
    _carrige.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_carrige.frame.size];

    _carrige.physicsBody.dynamic  = NO;
    _carrige.physicsBody.restitution = 0.0f;
    _carrige.physicsBody.categoryBitMask = CollisionCategoryPlatform;
    //_carrige.physicsBody.collisionBitMask = 0;
    _carrige.physicsBody.collisionBitMask = CollisionCategoryPlayer;
         // j = j+50;
    }
    
  
 
    return _carrige;
}


-(void)runGround
{
    SKSpriteNode *ground2 = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    ground2.anchorPoint = CGPointMake(0,0);
    //ground2.position = CGPointMake(self.frame.size.width -  CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    ground2.position = CGPointMake(960, -56); // set -56 optimize ground heigh is 50 above the bottom of the screen
    [self addChild:ground2];
    SKAction *action = [SKAction moveToX:-980 duration:16];
    [ground2 runAction:action];
    
    
}

-(void)runGround0
{
    SKSpriteNode *ground0 = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    ground0.anchorPoint = CGPointMake(0, 0);
    ground0.position    = CGPointMake(0, -56); // set -56 optimize ground heigh is 50 above the bottom of the screen
    groundHeigh =  ground0.size.height;
    [self addChild:ground0];
    SKAction *action0 = [SKAction moveToX:-960 duration:8];
    SKAction *rem = [SKAction removeFromParent]; //加这个语句没有减小内存使用虑
    SKAction *seq0 = [SKAction sequence:@[action0,rem]];
    [ground0 runAction:seq0 withKey:@"initAction"];

}


#pragma mark - monkey node

-(SKNode *)monkeyNode
{
    if (!_monkeyNode) {
    _monkeyNode = [SKNode node];
    //[_monkeyNode setScale:0.4];
        
    
    _monkeyNode.position =CGPointMake(CGRectGetMidX(self.frame)/3, 271);
    _monkeyNode.zPosition = 20;
        
    [self addMonkeyAnimationFrame];
        //_monkey.zPosition = 5;
    //_monkey.anchorPoint = CGPointMake(_monkey.size.width/2, 0);
    
  
    _monkeyNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_monkey.size ];  //SKnode is intangleble, so when you called bodyWithRectangleOfSize it based on bodyWithRectangleOfSize parameters.
      
     
    //_monkey.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_monkey.size center:CGPointMake(_monkey.size.width/2, _monkey.size.height/2)];
    //_monkeyNode.physicsBody.dynamic = NO;
    
    _monkeyNode.physicsBody.allowsRotation = NO;
    _monkeyNode.physicsBody.restitution = 0.0f;
    _monkeyNode.physicsBody.friction = 0.0f;
    _monkeyNode.physicsBody.angularDamping = 0.0f;
    _monkeyNode.physicsBody.linearDamping = 0.0f;
    _monkeyNode.physicsBody.mass = 1.0f;
    _monkeyNode.name = @"monkey";
    
    _monkeyNode.physicsBody.usesPreciseCollisionDetection = YES;
    _monkeyNode.physicsBody.categoryBitMask = CollisionCategoryPlayer;
    _monkeyNode.physicsBody.collisionBitMask = CollisionCategoryPlatform ;
    _monkeyNode.physicsBody.contactTestBitMask =  CollisionCategoryStar;
    
    }
    
    return _monkeyNode;
}
-(void)addMonkeyAnimationFrame
{
    //monkey move
    NSMutableArray *walkFrame = [NSMutableArray array];
    SKTextureAtlas *monkeyAtlas = [SKTextureAtlas atlasNamed:@"monkeyRun"];
    
    NSInteger numImages = monkeyAtlas.textureNames.count;
    for (int i=1; i<=numImages/2; i++) {
        NSString *textureNmae = [NSString stringWithFormat:@"monkey_run_%d",i];
        SKTexture *temp = [monkeyAtlas textureNamed:textureNmae];
        [walkFrame addObject:temp];
    }
    _monkeyRunFrame = walkFrame;
    SKTexture *temp = _monkeyRunFrame[0];
    _monkey = [SKSpriteNode spriteNodeWithTexture:temp];
    [_monkey setScale:0.4];
    //_monkey.position = CGPointMake(-_monkey.size.width/2, -_monkey.size.height/2);  // this is relativly node position 这个position往哪里贴，自己的位置就相当于往上贴的点的位置，这个要贴上node 所以就相当于node的postion (self.frame.size/3,30)
    //_monkey.anchorPoint = CGPointMake(0, 0); //anchorPoint only based on self position
    
   // monkeyHeigh = _monkey.size.height;
    [_monkey runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_monkeyRunFrame timePerFrame:0.1f]] withKey:RUNMONKEY];

    
    
}
/*
-(void)Addheart
{
    SKSpriteNode *Character = [SKSpriteNode spriteNodeWithImageNamed:@"heart.png"];
    
    Character.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:Character.size.width/2];
    Character.physicsBody.dynamic = NO;
    
    Character.physicsBody.categoryBitMask = CollisionCategoryStar;
    Character.physicsBody.collisionBitMask = CollisionCategoryPlayer;
    Character.physicsBody.contactTestBitMask  = CollisionCategoryPlayer;
    
    Character.position = CGPointMake(self.frame.size.width, 160);
    [self addChild:Character];
    
    SKAction *action = [SKAction moveToX:0  duration:5];
    SKAction *moveDown = [SKAction removeFromParent];
    
    [Character runAction:[SKAction sequence:@[action,moveDown]]];
    
}
*/
-(void)addPositiveCharacter
{
    SKNode *pnode = [SKNode node];
    
    int rangeY = self.frame.size.height * 4 /5 - self.frame.size.height / 5;
    pnode.position = CGPointMake(self.frame.size.width + 100, (arc4random()%rangeY) + self.frame.size.height /5 + 30 );
    
    pnode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(5, 5) ];
    pnode.physicsBody.dynamic = NO;
    pnode.physicsBody.categoryBitMask = CollisionCategoryPositiveCharacter;
    pnode.physicsBody.collisionBitMask = CollisionCategoryPlayer;
    pnode.physicsBody.contactTestBitMask  = CollisionCategoryPlayer;
    
    [self addChild:pnode];
    
    SKAction *ska = [SKAction moveToX:-10 duration:5];
    SKAction *rem = [SKAction removeFromParent];
    SKAction *seq1 = [SKAction sequence:@[ska,rem]];
    [pnode runAction:seq1 withKey:@"positiveObject"];
    
    NSString *imageName = [NSString stringWithFormat:@"sz%d",arc4random()%43 + 1  ];
    SKSpriteNode *spriteImage = [SKSpriteNode spriteNodeWithImageNamed:imageName ];
    [pnode addChild:spriteImage];
    
}

-(void)addNegativeCharacter
{
    SKNode *nnode = [SKNode node];
    int rangeY = self.frame.size.height * 4 /5 - self.frame.size.height / 5;
    
    nnode.position = CGPointMake(self.frame.size.width + 100, (arc4random()%rangeY) + self.frame.size.height /5  );
    
   // int rangY = 320;
    
   // nnode.position = CGPointMake(self.frame.size.width + 100, (arc4random()%rangY) + 60);
    
    nnode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(5, 5) ];
    nnode.physicsBody.dynamic = NO;
    nnode.physicsBody.categoryBitMask = CollisionCategoryNegativeCahracter;
    nnode.physicsBody.collisionBitMask = CollisionCategoryPlayer;
    nnode.physicsBody.contactTestBitMask  = CollisionCategoryPlayer;
    
    [self addChild:nnode];
    
    SKAction *ska = [SKAction moveToX:-10 duration:5];
    SKAction *rem = [SKAction removeFromParent];
    SKAction *seq1 = [SKAction sequence:@[ska,rem]];
    [nnode runAction:seq1 withKey:@"negativeObject"];
    
    j = arc4random()%4 + 1;
 
    NSString *imageName = [NSString stringWithFormat:@"nsz%d",j  ];
    SKSpriteNode *spriteImage = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    [nnode addChild:spriteImage];
    if (j == 4) {
        SKAction *action = [SKAction rotateByAngle: -M_PI/4 duration:2];
        [spriteImage runAction:action];
    }
    
}

-(void)faintedMonkeyfun
{
    _faintedMonkey = [SKSpriteNode spriteNodeWithImageNamed:@"monkey_dead"];
    
    _faintedMonkey.position = CGPointMake(_monkeyNode.position.x, _monkeyNode.position.y);
    [_faintedMonkey setScale:scale];
    
    [self addChild:_faintedMonkey];
    
    _faintedMonkey.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_faintedMonkey.size.width/2];
    _faintedMonkey.physicsBody.dynamic = YES;
    
    _faintedMonkey.physicsBody.velocity = CGVectorMake(0, 2);
    
    _faintedMonkey.physicsBody.categoryBitMask  = CollisioncategoryFaintedMonkey;
    _faintedMonkey.physicsBody.collisionBitMask  = 0;
    
    
}

-(void)addCloud
{
    NSString *clouds = [NSString stringWithFormat:@"object_cloud%d",arc4random()%2 + 1];
    SKSpriteNode *cloud1 = [SKSpriteNode spriteNodeWithImageNamed:clouds];
    
    
    int rangeY = self.frame.size.height  - self.frame.size.height * 2 / 5;
    
    cloud1.position = CGPointMake(self.frame.size.width + 100, (arc4random()%rangeY) + self.frame.size.height * 2 /5  );
    cloud1.anchorPoint = CGPointMake(0, 0);
    cloud1.zPosition = -2;
    
    [self addChild:cloud1];
    
    SKAction *ska = [SKAction moveToX:-self.frame.size.width/2 duration:8];
    SKAction *rem = [SKAction removeFromParent];
    SKAction *seq1 = [SKAction sequence:@[ska,rem]];
    
    [cloud1 runAction:seq1];
}

-(void)addTree
{
    SKSpriteNode *tree = [SKSpriteNode spriteNodeWithImageNamed:@"object_tree"];
    tree.anchorPoint = CGPointMake(0, 0);
    tree.position = CGPointMake(self.size.width + 100, 40);
    tree.zPosition = -1;
    [tree setScale:0.4];
    
    [self addChild:tree];
    
    SKAction *ska = [SKAction moveToX:-self.frame.size.width/2 duration:10];
    SKAction *rem = [SKAction removeFromParent];
    SKAction *seq1 = [SKAction sequence:@[ska,rem]];
    
    [tree runAction:seq1];
    
    
}

-(void)addMountain
{
    NSString *mountain = [NSString stringWithFormat:@"object_mountain%d",arc4random()%2+1];
    SKSpriteNode *mountains = [SKSpriteNode spriteNodeWithImageNamed:mountain];
    mountains.anchorPoint = CGPointMake(0, 0);
    mountains.position = CGPointMake(self.size.width + 100, 40);
    mountains.zPosition = -3;
    
    [self addChild:mountains];
    
    
    SKAction *ska = [SKAction moveToX:-self.frame.size.width/2 duration:12];
    SKAction *rem = [SKAction removeFromParent];
    SKAction *seq1 = [SKAction sequence:@[ska,rem]];
    
    [mountains runAction:seq1];
}





//log off code

//ground2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground2.frame.size];
//ground2.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(960, -75, ground2.size.width, ground2.size.height)];
// ground2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ground2.size.width];
//ground2.physicsBody.dynamic = NO;

//ground2.physicsBody.categoryBitMask = CollisionCategoryPlatform;
//ground2.physicsBody.collisionBitMask = CollisionCategoryPlayer;

//ground0.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground0.frame.size];
//ground0.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ground0.size.width center:CGPointMake(ground0.size.width/2, ground0.size.height/2)];
//ground0.physicsBody.dynamic = NO;

//ground0.physicsBody.categoryBitMask = CollisionCategoryPlatform;
//ground0.physicsBody.collisionBitMask = CollisionCategoryPlayer;

/*
 _monkey.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_monkey.size];
 //_monkey.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_monkey.size center:CGPointMake(_monkey.size.width/2, _monkey.size.height/2)];
 _monkey.physicsBody.dynamic = NO;
 
 _monkey.physicsBody.allowsRotation = NO;
 _monkey.physicsBody.restitution = 0.0f;
 _monkey.physicsBody.friction = 0.0f;
 _monkey.physicsBody.angularDamping = 0.0f;
 _monkey.physicsBody.linearDamping = 0.0f;
 _monkey.physicsBody.mass = 1.0f;
 _monkey.name = @"monkey";
 
 _monkey.physicsBody.categoryBitMask = CollisionCategoryPlayer;
 _monkey.physicsBody.collisionBitMask = CollisionCategoryPlatform;
 _monkey.physicsBody.contactTestBitMask =  CollisionCategoryPlatform;
 */
//propscale = propscale *1.01;
//[self.carrige removeFromParent];
//[_carrige removeFromParent];
//_carrige = nil;
// [self addChild:self.carrige];



@end
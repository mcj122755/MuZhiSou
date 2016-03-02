//
//  VolumeValue.h
//  BabyJump
//
//  Created by suoyong on 6/25/15.
//  Copyright (c) 2015 suoyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol Shouldpromptcahngdelegate <NSObject>

-(void)displayVale;

@end

@interface VolumeValue : NSObject

@property (nonatomic,assign) CGFloat voiceValue;
//@property (nonatomic,weak) id<Shouldpromptcahngdelegate> delegate;



@property (nonatomic,weak) id<Shouldpromptcahngdelegate>delegate;

//@property (nonatomic,weak) id<Shouldpromptcahngdelegate>delegate;  //2015 07 20以前就是这个


@end

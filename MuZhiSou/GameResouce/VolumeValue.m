//
//  VolumeValue.m
//  BabyJump
//
//  Created by suoyong on 6/25/15.
//  Copyright (c) 2015 suoyong. All rights reserved.
//

#import "VolumeValue.h"

@interface VolumeValue()

@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) NSDictionary *recordSetting;


@end

@implementation VolumeValue

-(id)init
{
    if(self = [super init]){
        
        NSString * path = NSTemporaryDirectory();
        NSString * path1 = [path stringByAppendingPathComponent:@"wav.wav"];
        
        NSURL * url = [NSURL URLWithString:path1];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        
        self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:self.recordSetting error:nil];
        [self.recorder prepareToRecord];
        self.recorder.meteringEnabled = YES;
        [self.recorder record];
        
        [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(currentVoice) userInfo:nil repeats:YES];
        
        //值永远是120时的检查 1，  share Instance 和 setCategory 2，［self.record record］ 3，enabled
        
    }
    
    return self;
    
}

-(void)currentVoice
{
    [self.recorder updateMeters];
    
    self.voiceValue = [self.recorder averagePowerForChannel:0];
    
    [self.delegate displayVale];
    
    if (self.voiceValue > -30) {
      

    }
    
    
}



@end

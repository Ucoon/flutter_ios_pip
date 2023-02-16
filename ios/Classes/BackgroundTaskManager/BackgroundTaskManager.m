//
//  BackgroundTaskManager.m
//  flutter_ios_pip
//
//  Created by Yardi_WuHan on 2023/2/14.
//

#import "BackgroundTaskManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface BackgroundTaskManager()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation BackgroundTaskManager

///创建单例
+ (BackgroundTaskManager *)shareManager{
    static BackgroundTaskManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BackgroundTaskManager alloc]init];
    });
    return  manager;
}

///开始播放
- (void)startPlayAudioSession{
    [self.audioPlayer play];
}

///停止播放
- (void)stopPlayAudioSession{
    [self.audioPlayer stop];
}

- (AVAudioPlayer *)audioPlayer{
    if(!_audioPlayer){
        //设置后台模式和锁屏模式下依然能够播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        //初始化音频模仿器
        NSError *playerError;
        NSURL *urlSound = [[NSURL alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"pomodoSound" ofType:@"wav"]];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlSound error:&playerError];
        _audioPlayer.numberOfLoops = -1;//无限循环
        _audioPlayer.volume = 0;
    }
    return _audioPlayer;
}

@end

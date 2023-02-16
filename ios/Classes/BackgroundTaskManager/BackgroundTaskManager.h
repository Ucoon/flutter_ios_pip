//
//  BackgroundTaskManager.h
//  flutter_ios_pip
//
//  Created by Yardi_WuHan on 2023/2/14.
//
// 后台保活工具

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BackgroundTaskManager : NSObject

///创建单例
+ (BackgroundTaskManager *)shareManager;

///开始播放
- (void)startPlayAudioSession;

///停止播放
- (void)stopPlayAudioSession;

@end

NS_ASSUME_NONNULL_END

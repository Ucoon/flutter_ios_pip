//
//  SceneDelegate.m
//  flutter_ios_pip
//
//  Created by Yardi_WuHan on 2023/2/14.
//

#import "SceneDelegate.h"
#import "BackgroundTaskManager.h"

@interface SceneDelegate ()

@property UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions API_AVAILABLE(ios(13.0)){
    
}

- (void)sceneDidDisconnect:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    
}

- (void)sceneDidBecomeActive:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    //停止播放
    [[BackgroundTaskManager shareManager] stopPlayAudioSession];
}

- (void)sceneWillResignActive:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    
}

- (void)sceneWillEnterForeground:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    
}

- (void)sceneDidEnterBackground:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    //开始播放
    [[BackgroundTaskManager shareManager] startPlayAudioSession];
}
@end

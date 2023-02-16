#import "FlutterIosPipPlugin.h"
#import <AVKit/AVKit.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface FlutterIosPipPlugin () <AVPictureInPictureControllerDelegate>
{
    UIWindow *firstWindow; //画中画
}

@property (nonatomic, strong) UIImageView *pipImageView; //画中画展示
@property (nonatomic, strong) UILabel *placeholderLab;//开启画中画占位


@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer; //播放内容
@property (nonatomic, strong) AVPictureInPictureController *pipVC; //画中画控制器

@end

@implementation FlutterIosPipPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_ios_pip"
            binaryMessenger:[registrar messenger]];
  FlutterIosPipPlugin* instance = [[FlutterIosPipPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"handleMethodCall method: %@", call.method);
    if ([@"isPictureInPictureSupported" isEqualToString:call.method]) {
        result([NSNumber numberWithBool: [self isPictureInPictureSupported]]);
    } else if([@"isPictureInPictureActive" isEqualToString:call.method]) {
        result([NSNumber numberWithBool: [self isPictureInPictureActive]]);
    } else if([@"initPictureInPicture" isEqualToString:call.method]){
        [self initPictureInPicture];
    } else if([@"startPictureInPicture" isEqualToString:call.method]){
        [self.pipVC startPictureInPicture];
    } else if([@"stopPictureInPicture" isEqualToString:call.method]){
        [self.pipVC stopPictureInPicture];
    } else {
      result(FlutterMethodNotImplemented);
    }
}

//判断是否支持画中画功能
- (Boolean) isPictureInPictureSupported{
    return  [AVPictureInPictureController isPictureInPictureSupported];
}

//判断画中画是否已开启
- (Boolean) isPictureInPictureActive{
    return  self.pipVC.isPictureInPictureActive;
}

//初始化
- (void) initPictureInPicture {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    self.pipVC = [[AVPictureInPictureController alloc]initWithPlayerLayer:self.playerLayer];
    self.pipVC.delegate = self;
    [self.pipVC setValue:@1 forKey:@"controlsStyle"];
}

#pragma mark --- 画中画代理
//即将开启画中画
- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{
    NSLog(@"pictureInPictureControllerWillStartPictureInPicture");
    firstWindow = [UIApplication sharedApplication].windows.firstObject;
    //添加kvo监听大小改变
    [firstWindow addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    _pipImageView.frame=CGRectMake(0, 0, firstWindow.bounds.size.width, firstWindow.bounds.size.height);
    [firstWindow addSubview:self.pipImageView];
}

//已经开启画中画
- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{
    NSLog(@"pictureInPictureControllerDidStartPictureInPicture");
    //先加遮盖
    [self.playerLayer addSublayer:self.placeholderLab.layer];
}

//开启画中画失败
- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error{
    NSLog(@"pictureInPictureController error: %@", error.description);
}

//即将关闭画中画
- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{
    NSLog(@"pictureInPictureControllerWillStopPictureInPicture");
}

//已经关闭画中画
- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{
    NSLog(@"pictureInPictureControllerDidStopPictureInPicture");
}

//关闭画中画且恢复播放界面
- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler{
    completionHandler(YES);
}

//frame改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"frame"]){
        _pipImageView.frame=CGRectMake(0, 0, firstWindow.bounds.size.width, firstWindow.bounds.size.height);
    }
}

#pragma mark ---lazyload
- (UIImageView *)pipImageView{
    if(!_pipImageView){
        _pipImageView = [[UIImageView alloc] init];
        _pipImageView.image = [UIImage imageNamed: [self getAppIconName]];
        _pipImageView.layer.cornerRadius = CGRectGetHeight(_pipImageView.bounds) / 2;
        _pipImageView.layer.masksToBounds = YES;
        _pipImageView.layer.borderWidth = 10;
        _pipImageView.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    return _pipImageView;
}

- (UILabel *)placeholderLab{
    if(!_placeholderLab){
        _placeholderLab = [[UILabel alloc]initWithFrame:CGRectMake(0, -1, ScreenWidth-60, (ScreenWidth-60)*0.75+2)];
        _placeholderLab.backgroundColor = [UIColor whiteColor];
        _placeholderLab.textAlignment = NSTextAlignmentCenter;
        _placeholderLab.textColor = [UIColor lightGrayColor];
        _placeholderLab.font = [UIFont systemFontOfSize:13.0];
        _placeholderLab.numberOfLines = 0;
    }
    return _placeholderLab;
}


- (AVPlayerLayer *)playerLayer{
    if(!_playerLayer){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"holder" ofType:@"mp4"];
        NSURL *sourceMovieUrl = [NSURL fileURLWithPath:path];
        self.avPlayer = [[AVPlayer alloc]initWithURL:sourceMovieUrl];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
        _playerLayer.frame = CGRectMake(30, 60, ScreenWidth-60, (ScreenWidth-60)*0.75);
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerLayer.cornerRadius = 10.0;
        _playerLayer.masksToBounds = YES;
    }
    return _playerLayer;
}

//获取appIconName
-(NSString *) getAppIconName{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    return icon;
}
@end

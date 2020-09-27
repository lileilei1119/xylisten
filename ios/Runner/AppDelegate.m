#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <AVFoundation/AVFoundation.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    // 告诉app支持后台播放
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground:");
    [application beginReceivingRemoteControlEvents];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground:");
    [application endReceivingRemoteControlEvents];
}

#pragma mark - 后台播放

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay: {
//            [[HYJingDongTTSManager sharedJingDongTTS] resumeCompoundVoice];
        }
            break;
        case UIEventSubtypeRemoteControlPause: {
//            [[HYJingDongTTSManager sharedJingDongTTS] pauseCompoundVoice];
            break;
        }
        case UIEventSubtypeRemoteControlPreviousTrack: {//上一曲
            
            
            break;
        }
        case UIEventSubtypeRemoteControlNextTrack: {//下一曲
            
            break;
        }
        case UIEventSubtypeRemoteControlTogglePlayPause: {//小窗口暂停
//            [[HYJingDongTTSManager sharedJingDongTTS] pauseCompoundVoice];
            NSLog(@"---------点击小窗口暂停按钮");
            break;
        }
        default:
            break;
    }
}



@end

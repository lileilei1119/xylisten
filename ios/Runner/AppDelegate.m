#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <AVFoundation/AVFoundation.h>

#if __has_include(<xy_tts/XyTtsPlugin.h>)
#import <xy_tts/XyTtsPlugin.h>
#else
@import xy_tts;
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

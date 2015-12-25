//
//  AppDelegate.m
//  MoviePlayer
//
//  Created by admin on 15/9/19.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HTTPServer.h"

@interface AppDelegate ()
{
    HTTPServer *_httpServer;
    ViewController *_mainController;
}
@end

@implementation AppDelegate

-(void)startServer
{
    //开启服务器
    NSError *error;
    if ([_httpServer start:&error])
    {
        NSLog(@"开启服务器成功 端口：%hu",[_httpServer listeningPort]);
    }
    else
        NSLog(@"发生错误：%@",[error localizedDescription]);

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
   
    _httpServer = [[HTTPServer alloc]init];
    
    [_httpServer setType:@"_http._tcp."];
    [_httpServer setPort:1234];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Movies/Temp"];
    
   // NSLog(@"%@",webPath);
    if (![fileManager fileExistsAtPath:webPath]) {
        [fileManager createDirectoryAtPath:webPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [_httpServer setDocumentRoot:webPath];
    [self startServer];
    
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];

    
   _mainController = [[ViewController alloc]init];
    UINavigationController *NC = [[UINavigationController alloc]initWithRootViewController:_mainController];
    [NC.navigationBar setBarTintColor:[UIColor lightGrayColor]];
    

    [_window setRootViewController:NC];
    [_window setBackgroundColor:[UIColor whiteColor]];
    [_window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
  static NSUInteger  dir = UIInterfaceOrientationMaskPortrait;
    if (_mainController && _mainController.isFull)
    {
        dir = UIInterfaceOrientationMaskLandscapeLeft;
    }
    else
        dir = UIInterfaceOrientationMaskPortrait;
    return dir;

}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [_httpServer stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self startServer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

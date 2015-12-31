//
//  AppDelegate.m
//  SliderMenu
//
//  Created by Wynter on 15/12/31.
//  Copyright © 2015年 Wynter. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "MainViewController.h"
#import "SliderRootViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    LeftViewController *leftVC = [[LeftViewController alloc]init];
    MainViewController *mainVC = [[MainViewController alloc]init];
    SliderRootViewController *sliderVC = [[SliderRootViewController alloc]init];
    [sliderVC addChildViewController:leftVC mainViewController:mainVC];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sliderVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end

//
//  ZOAppDelegate.m
//  ZOZolaZoomTransition
//
//  Created by Charles Scalesse on 7/10/15.
//  Copyright (c) 2015 Zola. All rights reserved.
//

#import "ZOAppDelegate.h"
#import "ZOProductsViewController.h"

@interface ZOAppDelegate ()

@end

@implementation ZOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ZOProductsViewController *productsController = [[ZOProductsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:productsController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    self.window.tintColor = [UIColor colorWithRed:80.0/255.0 green:178.0/255.0 blue:189.0/255.0 alpha:1.0];
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    return YES;
}

@end

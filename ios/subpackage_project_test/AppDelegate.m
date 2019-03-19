/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"
#import "RootViewController.h"
#import <React/RCTBridge.h>
#import "HHZRNRouteManager.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  RootViewController * vc = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
  UINavigationController * nac = [[UINavigationController alloc] initWithRootViewController:vc];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.rootViewController = nac;
  [self.window makeKeyAndVisible];
  return YES;
}

@end

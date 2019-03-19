//
//  RNViewController.m
//  subpackage_project_test
//
//  Created by yunshan on 2019/3/15.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RNViewController.h"
#import "HHZRNRouteManager.h"

@interface RNViewController ()

@end

@implementation RNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [self loadRCTView];
}

-(void)loadRCTView
{
  __weak typeof(self) weakSelf = self;
  [[HHZRNRouteManager shareManager] generateRCTViewWithKey:self.key callback:^(RCTRootView * _Nullable view) {
    if (view) {
      weakSelf.view = view;
    }
  }];
}

@end

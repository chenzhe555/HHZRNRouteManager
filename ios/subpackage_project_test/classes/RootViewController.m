//
//  RootViewController.m
//  subpackage_project_test
//
//  Created by yunshan on 2019/3/15.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RootViewController.h"
#import "HHZRNRouteManager.h"
#import "RNViewController.h"
#import <HHZAlert/HHZToastView.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  [self loadBundles];
  if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"load_once"] boolValue]) {
    [self downloadBundle];
  }
}



-(void)loadBundles
{
  NSMutableArray * mutaArr = [NSMutableArray array];
  HHZRNRouteModel * model1 = [[HHZRNRouteModel alloc] init];
  model1.key = @"COMMON_KEY";
  model1.isPreLoad = YES;
  model1.valueModel.bundleName = @"common";
  model1.valueModel.moduleName = @"";
  
  HHZRNRouteModel * model2 = [[HHZRNRouteModel alloc] init];
  model2.key = @"GOODS_DETAIL_KEY";
  model2.isPreLoad = YES;
  model2.valueModel.bundleName = @"goodsdetail";
  model2.valueModel.moduleName = @"goodsdetail";
  
  HHZRNRouteModel * model3 = [[HHZRNRouteModel alloc] init];
  model3.key = @"ORDER_LIST_KEY";
  model3.isPreLoad = YES;
  model3.valueModel.bundleName = @"orderlist";
  model3.valueModel.moduleName = @"orderlist";
  
  HHZRNRouteModel * model4 = [[HHZRNRouteModel alloc] init];
  model4.key = @"SECKILL_KEY";
  model4.isPreLoad = YES;
  model4.valueModel.bundleName = @"seckill";
  model4.valueModel.moduleName = @"seckill";
  
  [mutaArr addObject:model1];
  [mutaArr addObject:model2];
  [mutaArr addObject:model3];
  [mutaArr addObject:model4];
  
  [[HHZRNRouteManager shareManager] startWithCache:NO modelArray:mutaArr callback:^(BOOL success, NSDictionary *dic) {

  }];
}

-(void)downloadBundle
{
  [[HHZRNRouteManager shareManager] downloadBundleZipFile:@"http://localhost/xy3.zip" processHandler:^(NSString * _Nonnull source, long loadNum, long totalNum) {
    
  } completionHandler:^(NSString * _Nonnull path, BOOL success, NSError * _Nullable error) {
    if (success && !error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [[HHZToastView shareManager] showToastInCenter:@"下载成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"load_once"];
          [[HHZRNRouteManager shareManager] reloadCallback:^(BOOL success, NSDictionary *dic) {
            
          }];
        });
      });
    }
  }];
}


- (IBAction)goToGoodsDetailAction:(id)sender {
  RNViewController * vc = [[RNViewController alloc] init];
  vc.key = @"GOODS_DETAIL_KEY";
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goToOrderListAction:(id)sender {
  RNViewController * vc = [[RNViewController alloc] init];
  vc.key = @"ORDER_LIST_KEY";
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goToSeckillAction:(id)sender {
  RNViewController * vc = [[RNViewController alloc] init];
  vc.key = @"SECKILL_KEY";
  [self.navigationController pushViewController:vc animated:YES];
}


@end

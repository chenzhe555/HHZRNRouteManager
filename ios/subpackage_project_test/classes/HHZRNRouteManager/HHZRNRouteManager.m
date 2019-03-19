//
//  HHZRNRouteManager.m
//  subpackage_project_test
//
//  Created by yunshan on 2019/3/15.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "HHZRNRouteManager.h"
#import "RCTBridge+HHZLoadOtherJS.h"
#import <SSZipArchive/SSZipArchive.h>


@interface HHZRNRouteManager()
//加载Bundle模型数组
@property (nonatomic, strong) NSArray<HHZRNRouteModel *> * modelArray;
//是否已初始化加载过bridge
@property (nonatomic, assign) BOOL isLoadOnce;
//常量对象
@property (nonatomic, strong) HHZRNRouteManagerConstant * constantModel;
//加载多bundle队列
@property (nonatomic, strong) NSMutableArray * loadJSArray;
//加载JS回调
@property (nonatomic, copy) LoadJSBundleHandler loadCallback;
//生成RCTView回调
@property (nonatomic, strong) NSMutableArray * generateRCTViewCallbackArray;
@end

@implementation HHZRNRouteManager
+(instancetype)shareManager
{
  static HHZRNRouteManager * manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [HHZRNRouteManager new];
    manager.modelArray = @[];
    manager.loadJSArray = [NSMutableArray array];
    manager.generateRCTViewCallbackArray = [NSMutableArray array];
    manager.constantModel = [HHZRNRouteManagerConstant new];
    [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(loadJSSuccess:) name:RCTJavaScriptDidLoadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(loadJSFail:) name:RCTJavaScriptDidFailToLoadNotification object:nil];
  });
  return manager;
}

-(void)modifyConstantModel:(HHZRNRouteManagerConstant *)model
{
  self.constantModel = model;
}

-(void)updateCacheModelArray:(NSArray<HHZRNRouteModel *> *)modelArray
{
  [NSKeyedArchiver archiveRootObject:modelArray toFile:[self getModelCacheUrl]];
}

-(void)startWithCache:(BOOL)isCache modelArray:(NSArray<HHZRNRouteModel *> *)modelArray callback:(nonnull LoadJSBundleHandler)loadJSCallback
{
  self.loadCallback = loadJSCallback;
  //缓存判断
  if (isCache) {
    NSArray * cacheArr = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getModelCacheUrl]];
    if (cacheArr.count > 0) {
      self.modelArray = cacheArr;
    } else {
      if (modelArray.count > 0) {
        self.modelArray = modelArray;
      }
    }
  } else {
    self.modelArray = modelArray;
  }
  
  //加载Bundle
  for (HHZRNRouteModel * model in self.modelArray) {
    if (model.isPreLoad) {
      model.sourceType = 1;
      [self.loadJSArray addObject:model];
    }
  }
  
  //更新model缓存数组
  [self updateCacheModelArray:self.modelArray];
  //加载JSBundle
  [self loadJSBundle];
}

/**
 加载JSbundle二进制到JS环境
 */
-(void)loadJSBundle
{
  if (self.loadJSArray.count > 0) {
    HHZRNRouteModel * model = self.loadJSArray[0];
    if (self.isLoadOnce) {
      if (!model.valueModel.isHaveLoad) {
        //获取Bundle文件地址
        NSURL * bundleURL = [NSURL URLWithString:[self getBundleURLString:model.valueModel.bundleName]];
        if (bundleURL) {
          NSError *error = nil;
          NSData * otherBundleData = [NSData dataWithContentsOfFile:bundleURL.path options:NSDataReadingMappedIfSafe error:&error];
          if (!error) {
            //加载其它bundle文件
            [self.bridge.batchedBridge executeSourceCode:otherBundleData sync:YES];
          }
        }
      } else {
        //如果已存在，删除对应数据源
        [self.loadJSArray removeObjectAtIndex:0];
        [self loadJSBundle];
      }
    } else {
      if(self.bridge) [self.bridge invalidate];
      self.bridge = [[RCTBridge alloc] initWithBundleURL:[NSURL URLWithString:[self getBundleURLString:model.valueModel.bundleName]] moduleProvider:nil launchOptions:nil];
    }
  }
}

-(void)reloadCallback:(LoadJSBundleHandler)callback
{
  self.isLoadOnce = NO;
  for (HHZRNRouteModel * model in self.modelArray) {
    model.valueModel.isHaveLoad = NO;
    model.sourceType = 1;
  }
  [self startWithCache:NO modelArray:self.modelArray callback:callback];
  [self.bridge reload];
}

-(void)loadJSSuccess:(NSNotification *)noti
{
  [self handleLoadJSNotification:YES];
}

-(void)loadJSFail:(NSNotification *)noti
{
  //暂时先这么处理，后续有时间了调试弄
  [self handleLoadJSNotification:NO];
}


/**
 处理JS文件加载结果

 @param success 是否加载成功（目前没测Fail的情况）
 */
-(void)handleLoadJSNotification:(BOOL)success
{
  if (success) NSLog(@"ssssss---loadJSSuccess\n");
  if (self.loadJSArray.count > 0) {
    if (success && !self.isLoadOnce) self.isLoadOnce = YES;
    HHZRNRouteModel * model = self.loadJSArray[0];
    //组件已加载
    model.valueModel.isHaveLoad = success;
    if (model.sourceType == 2 && model.generateRCTViewCallback) {
      model.generateRCTViewCallback(success ? [self getRCTView:model] : nil);
      model.generateRCTViewCallback = nil;
    }
    [self.loadJSArray removeObjectAtIndex:0];
    //更新缓存
    [self updateCacheModelArray:self.modelArray];
    [self judgeLoadAllBundle];
    //继续加载
    [self loadJSBundle];
  }
}


/**
 判断当前是否已加载所有(startWithCache处用)
 */
-(void)judgeLoadAllBundle
{
  if(self.loadCallback) {
    BOOL loadAll = YES;
    for (HHZRNRouteModel * model in self.loadJSArray) {
      if (model.sourceType == 1) {
        loadAll = NO;
        break;
      }
    }
    if (loadAll) {
      self.loadCallback(YES, @{});
      self.loadCallback = nil;
    }
  }
}

-(void)generateRCTViewWithKey:(NSString *)key callback:(nonnull GenerateRCTViewHandler)callback
{
  NSString * bundleName = nil;
  for (HHZRNRouteModel * model in self.modelArray) {
    if ([model.key isEqualToString:key]) {
      bundleName = model.valueModel.bundleName;
      if (model.valueModel.isHaveLoad) {
        callback([self getRCTView:model]);
      } else {
        model.sourceType = 2;
        model.generateRCTViewCallback = callback;
        [self.loadJSArray addObject:model];
        [self loadJSBundle];
      }
      break;
    }
  }
  //如果没取到key对应的bundle信息，则返回nil
  if (bundleName.length <= 0) callback(nil);
}


/**
 生成RCTView
 */
-(RCTRootView *)getRCTView:(HHZRNRouteModel *)model
{
  return [[RCTRootView alloc] initWithBridge:self.bridge moduleName:model.valueModel.moduleName initialProperties:nil];
}

-(void)downloadBundleZipFile:(NSString *)urlString processHandler:(ProgressHandler)processHandler completionHandler:(CompletionHandler)completionHandler
{
  [processHandler copy];
  [completionHandler copy];
  NSURLSessionDownloadTask * task = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (!error) {
      //解压到mainbundleh中
      [SSZipArchive unzipFileAtPath:location.path toDestination:[self getBundleURLString:nil] progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        if (processHandler) processHandler(entry, entryNumber, total);
      } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        if (completionHandler) completionHandler(path, succeeded, error);
      }];
    } else {
      if (completionHandler) completionHandler(@"", NO, [NSError errorWithDomain:@"文件下载失败!" code:111111 userInfo:nil]);
    }
  }];
  [task resume];
}

#pragma mark 辅助方法

/**
 获取bundle存储地址

 @param bundleName bundle名
 */
-(NSString *)getBundleURLString:(NSString * __nullable)bundleName
{
  NSLog(@"bundlePath:%@\n",[NSBundle mainBundle].bundleURL.path);
  NSMutableString * mutaStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@/",[NSBundle mainBundle].bundleURL.path]];
  if (bundleName) {
    if (self.constantModel.bundleBaseName.length > 0) [mutaStr appendString:[NSString stringWithFormat:@"%@/%@.bundle",self.constantModel.bundleBaseName,bundleName]];
  } else {
    if (self.constantModel.bundleBaseName.length > 0) [mutaStr appendString:[NSString stringWithFormat:@"%@",self.constantModel.bundleBaseName]];
  }
  return mutaStr;
}


/**
 获取Model数组缓存地址
 */
-(NSString *)getModelCacheUrl
{
  return [[NSBundle mainBundle].bundleURL.path stringByAppendingPathComponent:@"/modelCacheArray.plist"];
}

@end



@implementation HHZRNRouteManagerConstant
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.bundleBaseName = @"rnfiles";
  }
  return self;
}
@end

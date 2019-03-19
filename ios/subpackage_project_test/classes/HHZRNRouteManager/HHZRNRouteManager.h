//
//  HHZRNRouteManager.h
//  subpackage_project_test
//
//  Created by yunshan on 2019/3/15.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>
#import "HHZRNRouteModel.h"

//下载进度
typedef void (^ProgressHandler)(NSString * _Nonnull source, long loadNum, long totalNum);
//下载结果
typedef void (^CompletionHandler)(NSString * _Nonnull path, BOOL success, NSError * _Nullable error);
//Reload回调: dic 预留字段
typedef void (^LoadJSBundleHandler)(BOOL success, NSDictionary * dic);


NS_ASSUME_NONNULL_BEGIN

@interface HHZRNRouteManagerConstant : NSObject
//bundles存储的路径,默认存储在 jsbundles文件夹下，空串或者nil，默认就在mainbundle目录下
@property (nonatomic, copy) NSString * bundleBaseName;
@end

@interface HHZRNRouteManager : NSObject
//桥接bridge
@property (nonatomic, strong) RCTBridge * bridge;

#pragma mark 获取实例对象
/**
 获取当前Manager实例
 */
+(instancetype)shareManager;

#pragma mark 启动RouteManager

/**
 以配置文件启动(回调后再执行其它操作)

 @param isCache 如果走缓存，但是缓存中没有，则还是会取一次modelArray；可以都不走缓存，业务自己存储modelArray数据
 @param modelArray bundle配置数组
 */
-(void)startWithCache:(BOOL)isCache modelArray:(NSArray<HHZRNRouteModel *> * __nullable)modelArray callback:(LoadJSBundleHandler)loadJSCallback;


/**
 重启Bridge
 */
-(void)reloadCallback:(LoadJSBundleHandler)callback;


#pragma mark 生成RCTView
/**
 生成RCTView对象

 @param key 当前Key
 */
-(void)generateRCTViewWithKey:(NSString *)key callback:(nonnull GenerateRCTViewHandler)callback;


#pragma mark 下载补丁包
/**
 下载Bundle的Zip包

 @param url Zip包下载地址
 */
-(void)downloadBundleZipFile:(NSString *)urlString processHandler:(ProgressHandler)processHandler completionHandler:(CompletionHandler)completionHandler;


#pragma mark 配置信息

/**
 修改常量对象
 */
-(void)modifyConstantModel:(HHZRNRouteManagerConstant *)model;


/**
 更新缓存中的bundle配置数组
 
 @param modelArray
 */
-(void)updateCacheModelArray:(NSArray<HHZRNRouteModel *> *)modelArray;
@end

NS_ASSUME_NONNULL_END

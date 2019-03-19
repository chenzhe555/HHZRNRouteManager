//
//  HHZRNRouteModel.h
//  subpackage_project_test
//
//  Created by yunshan on 2019/3/15.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+MJCoding.h>
@class RCTRootView;

NS_ASSUME_NONNULL_BEGIN

//RCTView回调事件
typedef void (^GenerateRCTViewHandler)(RCTRootView * __nullable view);

@interface HHZRNRouteValueModel : NSObject<NSCoding>
//模块名称
@property (nonatomic, copy) NSString * moduleName;
//bundle的名称
@property (nonatomic, copy) NSString * bundleName;
//当前模块是否已加载过
@property (nonatomic, assign) BOOL isHaveLoad;
@end

@interface HHZRNRouteModel : NSObject<NSCoding>
//当前Route下Bundle对应的Key
@property (nonatomic, copy) NSString * key;
//是否预先加载
@property (nonatomic, assign) BOOL isPreLoad;
//key对应下的Value值
@property (nonatomic, strong) HHZRNRouteValueModel * valueModel;
//1.纯加载JS 2.加载并回调generateRCTViewCallback返回RCTView
@property (nonatomic, assign) NSInteger sourceType;
//生成RCTView回调
@property (nonatomic, copy) GenerateRCTViewHandler __nullable generateRCTViewCallback;
@end

NS_ASSUME_NONNULL_END

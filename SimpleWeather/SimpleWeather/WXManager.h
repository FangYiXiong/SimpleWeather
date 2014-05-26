//
//  WXManager.h
//  SimpleWeather
//
//  Created by Yixiong on 14-5-26.
//  Copyright (c) 2014年 Fang Yixiong. All rights reserved.
//
@import Foundation;
@import CoreLocation;
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import "WXCondition.h"
/**
 *  Useage:
 *  使用单例设计模式。
 *  试图找到设备的位置。
 *  找到位置后，获取相应的气象数据
 */


@interface WXManager : NSObject <CLLocationManagerDelegate>

// 使用instancetype而不是WXManager，子类将返回适当的类型。
+ (instancetype)sharedManager;

@property (strong, nonatomic, readonly) CLLocation *currentLocation;
@property (strong, nonatomic, readonly) WXCondition *currentCondition;
@property (strong, nonatomic, readonly) NSArray *hourlyForecast;
@property (strong, nonatomic, readonly) NSArray *dailyForecast;


// 4. 这个方法启动或刷新整个位置和天气的查找过程
- (void)findCurrentLocation;

@end

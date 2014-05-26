//
//  WXDailyForecast.m
//  SimpleWeather
//
//  Created by Yixiong on 14-5-26.
//  Copyright (c) 2014年 Fang Yixiong. All rights reserved.
//

#import "WXDailyForecast.h"

@implementation WXDailyForecast

// TODO: 我怎么觉得这里面有很大的问题...
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // 1 获取 WXCondition的映射并创建一份可变的拷贝 。
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    // 2    将最高气温和最低气温的映射改为每日预报中你所需要的。

    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    // 3    返回新的映射。
    return paths;
}

@end

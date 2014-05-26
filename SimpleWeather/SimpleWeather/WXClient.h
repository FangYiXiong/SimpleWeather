//
//  WXClient.h
//  SimpleWeather
//
//  Created by Yixiong on 14-5-26.
//  Copyright (c) 2014年 Fang Yixiong. All rights reserved.
//
@import CoreLocation;
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
@import Foundation;

// WXClient‘s sole responsibility is to create API requests and parse them; someone else can worry about what to do with the data and how to store it.
@interface WXClient : NSObject

- (RACSignal *)fetchJSONFromURL:(NSURL *)url;
- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate;

@end

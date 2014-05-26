//
//  WXClient.m
//  SimpleWeather
//
//  Created by Yixiong on 14-5-26.
//  Copyright (c) 2014年 Fang Yixiong. All rights reserved.
//

#import "WXClient.h"
#import "WXCondition.h"
#import "WXDailyForecast.h"

@interface WXClient()

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation WXClient


- (id)init{
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

// 主方法来建立一个信号从URL中取数据
- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    NSLog(@"Fetching: %@",url.absoluteString);
    
    // 1 返回信号
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 2 创建一个数据会话任务
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            // TODO: Handle retrieved data
            if (! error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (! jsonError) {
                    // 1. 当JSON数据存在并且没有错误，发送给订阅者序列化后的JSON数组或字典。
                    [subscriber sendNext:json];
                }
                else {
                    // 2 在任一情况下如果有一个错误，通知订阅者。
                    [subscriber sendError:jsonError];
                }
            }
            else {
                // 2 在任一情况下如果有一个错误，通知订阅者。
                [subscriber sendError:error];
            }
            
            // 3 无论该请求成功还是失败，通知订阅者请求已经完成。
            [subscriber sendCompleted];
        }];
        
        // 3. 启动网络请求。
        [dataTask resume];
        
        // 4. 创建并返回RACDisposable对象，它处理当信号摧毁时的清理工作。
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        // 5. 增加了一个“side effect”，以记录发生的任何错误。
        NSLog(@"%@",error);
    }];
}


// 获取当前状况
- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate {
    // 1. 使用CLLocationCoordinate2D对象的经纬度数据来格式化URL。
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 2. 用你刚刚建立的创建信号的方法。由于返回值是一个信号，你可以调用其他ReactiveCocoa的方法。 在这里，您将返回值映射到一个不同的值：一个NSDictionary实例。
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        // 3. 使用MTLJSONAdapter来转换JSON到WXCondition对象 – 使用MTLJSONSerializing协议创建的WXCondition。
        return [MTLJSONAdapter modelOfClass:[WXCondition class]
                         fromJSONDictionary:json error:nil];
    }];
}

// 根据坐标获取逐时预报的方法
- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial&cnt=12",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 1. 再次使用 -fetchJSONFromUR 方法，映射JSON
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        // 2. 使用JSON的”list”key创建RACSequence。 RACSequences让你对列表进行ReactiveCocoa操作。
        RACSequence *list = [json[@"list"] rac_sequence];
        
        // 3. 映射新的对象列表。调用-map：方法，针对列表中的每个对象，返回新对象的列表。
        return [[list map:^(NSDictionary *item) {
            // 4. 再次使用MTLJSONAdapter来转换JSON到WXCondition对象。
            return [MTLJSONAdapter modelOfClass:[WXCondition class] fromJSONDictionary:item error:nil];
            // 5. 使用RACSequence的-map方法，返回另一个RACSequence，所以用这个简便的方法来获得一个NSArray数据。
        }] array];
    }];
}

- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=imperial&cnt=7",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Use the generic fetch method and map results to convert into an array of Mantle objects
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        // Build a sequence from the list of raw JSON
        RACSequence *list = [json[@"list"] rac_sequence];
        
        // Use a function to map results from JSON to Mantle objects
        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[WXDailyForecast class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

@end

//
//  WXController.h
//  SimpleWeather
//
//  Created by Yixiong on 14-5-26.
//  Copyright (c) 2014年 Fang Yixiong. All rights reserved.
//
#import "GAITrackedViewController.h"
#import <UIKit/UIKit.h>

@interface WXController : GAITrackedViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
- (void)refreshBackgroundImage;
@end

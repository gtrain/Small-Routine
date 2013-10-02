//
//  Model.h
//  weather
//
//  Created by yang on 12-8-27.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
-(NSDictionary *) weatherInfo:(NSString *) cityName;
-(NSURL *) weatherImg:(NSString *) imgName;

@end

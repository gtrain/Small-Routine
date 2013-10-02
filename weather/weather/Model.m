    //
//  Model.m
//  weather
//
//  Created by yang on 12-8-27.
//  Copyright (c) 2012年 yang. All rights reserved.
//
/*
 NSData *cityData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 NSError *error;
 NSDictionary *cityInfo=[NSJSONSerialization JSONObjectWithData:cityData options:NSJSONReadingMutableLeaves error:&error];
 NSLog(@"%@",cityInfo);*/


#import "Model.h"

@interface Model ()
-(NSString *) getCityCode:(NSString *)city;
-(NSURL *) wholeUrl:(NSString *)cityCode;
@end

@implementation Model
static NSString *const weathPreUrl=@"http://m.weather.com.cn/data/";
static NSString *const cityPreUrl=@"http://toy.weather.com.cn/SearchBox/searchBox?callback=jsonp1342857491709&_=1342857620727&language=zh&keyword=";
static NSString *const weathImgPreUrl=@"http://m.weather.com.cn/img/b";

-(NSDictionary *) weatherInfo:(NSString *) cityName
{
    NSString *_cityCode = [self getCityCode:cityName];
    NSURL *url=[self wholeUrl:_cityCode];
    NSError *error;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherInfo = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    return weatherInfo; 
}

-(NSURL *) weatherImg:(NSString *) imgName
{
    NSMutableString *urlStr=[[NSMutableString alloc] initWithString:weathImgPreUrl];
    [urlStr appendString:imgName];
    [urlStr appendString:@".gif"];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}

-(NSString *) getCityCode:(NSString *)city
{
    NSString *cityUTF8 = [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *cityUrl=[[NSMutableString alloc] initWithString:cityPreUrl];
    [cityUrl appendString:cityUTF8];
    NSLog(@"请求的url%@",cityUrl);
    NSURL *url=[NSURL URLWithString:cityUrl];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    NSData *returnData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str=[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"返回的数据%@",str);
    
    int len=str.length-21;
    NSRange range=NSMakeRange(19, len);
    NSString *cutStr=[str substringWithRange:range];
    cutStr=[cutStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
    cutStr=[cutStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
    NSData* jsonData = [cutStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    
    return [[weatherDic objectForKey:@"i"] objectForKey:@"i"];
}

-(NSURL *) wholeUrl:(NSString *)cityCode
{
    NSMutableString *urlStr=[[NSMutableString alloc] initWithString:weathPreUrl];
    if (cityCode) {
        [urlStr appendString:cityCode];
    }
    [urlStr appendString:@".html"];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    return url;
}




@end

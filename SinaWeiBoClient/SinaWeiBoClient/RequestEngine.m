//
//  RequestEngine.m
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-9.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import "RequestEngine.h"

@implementation RequestEngine
-(void) dealloc{
    self.networkQueue=nil;
    [super dealloc];
}

//根据API跟参数组合url字符串，由于需要多次调用，所以在这里作为一个公共方法，供各类调用
+(NSURL *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params
{
    NSURL* parsedURL = [NSURL URLWithString:baseURL];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL, /* allocator */
                                                                                      (CFStringRef)[params objectForKey:key],
                                                                                      NULL, /* charactersToLeaveUnescaped */
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        [escaped_value release];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query]];
}

-(id) init{
    self=[super init];
    if (self) {
        [self netWorkInit];
    }
    return self;
}
-(void) netWorkInit{
    self.networkQueue=[ASINetworkQueue queue];      //获得网络队列实例
    _networkQueue.showAccurateProgress=YES;     //精确的进度
    _networkQueue.shouldCancelAllRequestsOnFailure=NO;
    
    //队列要处理  ASIHTTPRequest的Delegate
    _networkQueue.downloadProgressDelegate=self;//下载进程的代理
    _networkQueue.delegate=self;                //代理
    
    _networkQueue.requestDidStartSelector=@selector(requestStartedByQueue:);
    //self.networkQueue.requestDidReceiveResponseHeadersSelector=@selector(requestReceivedResponseHeaders:);
    _networkQueue.requestDidFinishSelector=@selector(requestFinishedByQueue:);
    _networkQueue.requestDidFailSelector=@selector(requestFailedByQueue:);
    _networkQueue.queueDidFinishSelector=@selector(queueFinished:);
    
    //设置完成，启动队列
    [_networkQueue go];
}

-(void) addRequestWithUrl:(NSURL *)url Method:(NSString *)requestMethod Tag:(RequestTag) tag{
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:url];
    [request setRequestMethod:requestMethod];
    request.tag=tag;
    [self.networkQueue addOperation:request];
    [request release];
}

-(void) addRequestWithRequest:(ASIHTTPRequest *)request Method:(NSString *)requestMethod Tag:(RequestTag) tag{
    [request setRequestMethod:requestMethod];
    request.tag=tag;
    [self.networkQueue addOperation:request];
    [request release];
}

#pragma mark --------NETWORKQUEUE---------
-(void) requestStartedByQueue:(ASIHTTPRequest *)request{
    NSLog(@"requestStartedByQueue,%@",request.url);
}

-(void) requestFinishedByQueue:(ASIHTTPRequest *)request{
    //根据不同的请求标示，发送对应的数据
    NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];
    if (request.tag==GetAccessToken) {          //获取token成功
        [[NSNotificationCenter defaultCenter] postNotificationName:DidGetAccessToken object:nil userInfo:userDictionary];
    }else if(request.tag==GetHomeStatus){       //获取公告微博成功
        [[NSNotificationCenter defaultCenter] postNotificationName:DidGetHomeStatus object:nil userInfo:userDictionary];
    }else if(request.tag==GetWeiboImages){      //获取微博的图片，包括头像跟配图
        NSString *url=[NSString stringWithFormat:@"%@",request.url];
        
            [self.delegate saveWeiboPicData:request.responseData withRequestUrlString:url];
    }else if(request.tag==GetPersonalInfo){     //获取个人信息
        [[NSNotificationCenter defaultCenter] postNotificationName:DidGetPersonalInfo object:nil userInfo:userDictionary];
    }else if(request.tag==GetPersonalAvatar){
        NSDictionary *avatarData=[NSDictionary dictionaryWithObjectsAndKeys:request.responseData,@"avaterData",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:DidGetPersonalAvatar object:nil userInfo:avatarData];
    }else if(request.tag==GetPersonalStatus){       //获取公告微博成功
        [[NSNotificationCenter defaultCenter] postNotificationName:DidGetPersonalStatus object:nil userInfo:userDictionary];
    }else if(request.tag==PostStatus){       
        NSLog(@"requestFinishedByQueue: %@",request.responseStatusMessage);
    }
}
-(void) requestFailedByQueue:(ASIHTTPRequest *) request{
    NSLog(@"requestFailedByQueue: %@",request.responseStatusMessage);
}

-(void) queueFinished:(ASIHTTPRequest *) request{
//  NSLog(@"queueFinished");
}

@end

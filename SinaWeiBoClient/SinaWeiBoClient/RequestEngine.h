//
//  RequestEngine.h
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-9.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"


@protocol GetWeiboImagesDelegate <NSObject>
-(void) saveWeiboPicData:(NSData *)PicData withRequestUrlString:(NSString *)url;
@end
//请求的tag，用枚举变量跟直观地区分
typedef enum{
    GetAccessToken=0,
    GetHomeStatus,
    GetWeiboImages,
    GetPersonalInfo,
    GetPersonalAvatar,
    GetPersonalStatus,
    PostStatus
} RequestTag;

@interface RequestEngine : NSObject
@property (nonatomic,retain) ASINetworkQueue *networkQueue;
@property (nonatomic,assign) id<GetWeiboImagesDelegate> delegate;  //获取到微博图形是，调用status更新

-(void) addRequestWithUrl:(NSURL *)url Method:(NSString *)requestMethod Tag:(RequestTag) tag;
-(void) addRequestWithRequest:(ASIHTTPRequest *)request Method:(NSString *)requestMethod Tag:(RequestTag) tag;
+(NSURL *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;
//+(RequestEngine *) requestEngine;   //返回一个实例变量
@end

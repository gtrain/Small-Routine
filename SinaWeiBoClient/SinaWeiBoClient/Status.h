//
//  Status.h
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-14.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Users.h"


@interface Status : NSObject<GetWeiboImagesDelegate>

@property (assign,nonatomic) long long weiboId;                 //微博id

@property (retain,nonatomic) NSNumber *weiboCellIndex;
@property (retain,nonatomic) RequestEngine *requestEngine;      //请求图片的时候可以看到
@property (retain,nonatomic) Users *user;   //根据用户json实例化
@property (retain,nonatomic) NSData *weiboThumbnailPicData;        //微博图片，文字加载后，利用链接异步加载
@property (retain,nonatomic) NSString *weibothumbnailPicUrl;    //缩略图链接，第一次加载时用于定制行高
@property (retain,nonatomic) NSString *weiboCreatedTime;        //微博发布时间， 要处理发布时间，转中文啊
@property (retain,nonatomic) NSString *weiboSource;             //微博来源 url？，（通过什么客户端）
@property (retain,nonatomic) NSString *weiboContent;            //微博
@property (retain,nonatomic) NSString *weiboRepostsCount;       //微博转发
@property (retain,nonatomic) NSString *weiboCommentsCount;      //微博评论
@property (retain,nonatomic) Status *retweetedStatus;           //转发的微博

+ (Status*)statusWithJsonDictionary:(NSDictionary*)dic;
-(void) getImagesDate;
@end

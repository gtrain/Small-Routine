//
//  Status.m
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-14.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import "Status.h"

@implementation Status

-(void) dealloc{
    self.requestEngine =nil;
    
    self.user =nil;
    self.weiboThumbnailPicData =nil;
    self.weibothumbnailPicUrl =nil;
    self.weiboCreatedTime =nil;
    self.weiboSource =nil;
    self.weiboContent =nil;
    self.weiboRepostsCount =nil;
    self.weiboCommentsCount =nil;
    self.retweetedStatus =nil;
    
    [super dealloc];
}

+ (Status*)statusWithJsonDictionary:(NSDictionary*)dic
{
	return [[[self alloc] initWithJsonDictionary:dic] autorelease];
}

- (Status*)initWithJsonDictionary:(NSDictionary*)dic {
	if (self = [super init]) {
        self.user=[Users userWithJsonDic:[dic objectForKey:@"user"]];
        self.weiboId=(long long)[dic objectForKey:@"id"];
        self.weiboCreatedTime=[dic objectForKey:@"created_at"];
        self.weiboSource=[dic objectForKey:@"source"];
        self.weiboContent=[dic objectForKey:@"text"];
        self.weiboRepostsCount=[dic objectForKey:@"reposts_count"];
        self.weiboCommentsCount=[dic objectForKey:@"comments_count"];
        self.retweetedStatus= [dic objectForKey:@"retweeted_status"] ==nil ? nil : [Status statusWithJsonDictionary:[dic objectForKey:@"retweeted_status"]];

        //有转发，跟有图片是相互矛盾的
        if (!_retweetedStatus) {     
            self.weibothumbnailPicUrl=[dic objectForKey:ThumbnailPic];
        }
        
	}
	return self;
}

-(void) getImagesDate{
    self.requestEngine=[[RequestEngine alloc] init];
    [_requestEngine setDelegate:self];
    [_requestEngine addRequestWithUrl:[NSURL URLWithString:_user.userProfilePicUrl] Method:@"GET" Tag:GetWeiboImages];
    
    if (_weibothumbnailPicUrl) {
        [_requestEngine addRequestWithUrl:[NSURL URLWithString:_weibothumbnailPicUrl] Method:@"GET" Tag:GetWeiboImages];
    }else if(_retweetedStatus.weibothumbnailPicUrl){
        [_requestEngine addRequestWithUrl:[NSURL URLWithString:_retweetedStatus.weibothumbnailPicUrl] Method:@"GET" Tag:GetWeiboImages];
    }
}

-(void) saveWeiboPicData:(NSData *)PicData withRequestUrlString:(NSString *)url{
    //NSLog(@"第%@条微博，收到图片",self.weiboCellIndex);
    if ([url isEqualToString:_weibothumbnailPicUrl]) {
        self.weiboThumbnailPicData=PicData;
    }
    else if([url isEqualToString:_retweetedStatus.weibothumbnailPicUrl]){
        self.retweetedStatus.weiboThumbnailPicData=PicData;
    }else{
        self.user.userProfilePicData=PicData;
    }
    
    NSNumber *indexNum=_weiboCellIndex;
    NSDictionary *userInfo=[NSDictionary dictionaryWithObjectsAndKeys:indexNum,WeiboCellIndexKey,nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:DidGetImagesStatus object:nil userInfo:userInfo];
}

@end










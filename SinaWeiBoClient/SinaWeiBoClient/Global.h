//
//  Global.h
//  WeiboClient_yzq
//
//  Created by yang on 13-2-11.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#ifndef WeiboClient_yzq_Global_h
#define WeiboClient_yzq_Global_h

//软件开发信息
#define APPKEY             @"4037834572"
#define APPSECRET          @"8175a3232cdd33551a62e7fc509b79e9"
#define APPREDIRECTURI     @"http://vdisk.weibo.com/u/1841185175"

//微博OA认证API
#define SINAWEIBOOAuth2APIDomain    @"https://open.weibo.cn/2/oauth2/"
#define SINAWEIBOAUTHORIZE          @"https://open.weibo.cn/2/oauth2/authorize"
#define SINAWEIBOWebAccessTokenURL  @"https://open.weibo.cn/2/oauth2/access_token"

//微博资料API
#define SINAweiboHomeStatuses       @"https://api.weibo.com/2/statuses/home_timeline.json"  //公告微博
#define SINAweiboPersonalInfo       @"https://api.weibo.com/2/users/show.json"              //用户信息
#define SINAweiboPersonalStatus      @"https://api.weibo.com/2/statuses/user_timeline.json" //用户微博

//通知中心
#define DIDGETCODE              @"GetCodeSuccess"
#define DidGetAccessToken       @"GetTokenSuccess"

#define DidGetHomeStatus        @"GetHomeStatusSuccess"
#define DidGetPersonalInfo      @"GetPersonalInfoSuccess"
#define DidGetPersonalStatus    @"GetPersonalStatusSuccess"
#define DidGetPersonalAvatar    @"DidGetPersonalAvatarSuccess"
#define DidGetPersonalStatus    @"GetPersonalStatusSuccess"

#define DidGetImagesStatus      @"GetWeiboImagesSuccess"
#define WeiboImageData          @"WeiboImageData"
#define WeiboCellIndexKey        @"WeiboCellIndex"
//    //异步加载图片的时候，用于识别什么图片
//#define WeiboImageType          @"WeiboImageType"
#define ThumbnailPic            @"thumbnail_pic"
#define ProfileImageUrl         @"profile_image_url"


//OAuth 认证信息
#define USER_CODE                 @"code"
#define USER_ACCESS_TOKEN         @"access_token"
#define USER_USER_ID              @"uid"
#define USER_EXPIRATION_DATE      @"expires_in"

#define USER_STATUS               @"status"
#define USER_PIC                  @"pic"


//微博API
#define URL_POSTSTATUSESWITHIMG         @"https://api.weibo.com/2/statuses/upload.json"
#define URL_POSTSTATUSES                @"https://api.weibo.com/2/statuses/update.json"

#define kSinaWeiboWebAccessTokenURL     @"https://open.weibo.cn/2/oauth2/access_token"
#define kSinaWeiboWebAuthURL            @"https://open.weibo.cn/2/oauth2/authorize"
#define kSinaWeiboUserInfo              @"https://open.weibo.cn/2/users/show.json"

#endif





/*
 //软件开发信息
 #define kAppKey             @"4037834572"
 #define kAppSecret          @"8175a3232cdd33551a62e7fc509b79e9"
 #define kAppRedirectURI     @"http://vdisk.weibo.com/u/1841185175"
 
 //OAuth 认证信息
 #define USER_STORE_CODE                 @"code"
 #define USER_STORE_ACCESS_TOKEN         @"access_token"
 #define USER_STORE_USER_ID              @"uid"
 #define USER_STORE_EXPIRATION_DATE      @"expires_in"
 
 #define USER_STORE_STATUS               @"status"
 #define USER_STORE_PIC                  @"pic"
 
 //通知中心:成功获取TOKEN信息
 #define DID_GET_CODE                    @"didGetCodeInWebView"
 
 //通知中心:截图完成，包含截图信息
 #define SCREENSHOTRECT                  @"screenShotRect"
 #define DID_GET_SNAPSHOT                @"didGetSnapShot"
 
 #define USER_INFO_KEY_TYPE              @"requestType"
 
 //微博字数限制
 #define MAXWORDLENGHT   140
 
 
 //微博API
 #define URL_POSTSTATUSESWITHIMG         @"https://api.weibo.com/2/statuses/upload.json"
 #define kSinaWeiboWebAccessTokenURL     @"https://open.weibo.cn/2/oauth2/access_token"
 #define kSinaWeiboWebAuthURL            @"https://open.weibo.cn/2/oauth2/authorize"
 #define kSinaWeiboUserInfo              @"https://open.weibo.cn/2/users/show.json"

*/
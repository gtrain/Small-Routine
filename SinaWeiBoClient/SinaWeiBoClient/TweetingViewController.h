//
//  TweetingViewController.h
//  SinaWeiBoClient
//
//  Created by yzq on 13-5-17.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SinaGetOauthCode = 0,           //authorize_code
    SinaGetOauthToken,              //access_token
    SinaGetRefreshToken,            //refresh_token
    SinaGetPublicTimeline,          //获取最新的公共微博
    SinaGetUserID,                  //获取登陆用户的UID
    SinaGetUserInfo,                //获取任意一个用户的信息
    SinaGetBilateralIdList,         //获取用户双向关注的用户ID列表，即互粉UID列表
    SinaGetBilateralIdListAll,
    SinaGetBilateralUserList,       //获取用户的双向关注user列表，即互粉列表
    SinaGetBilateralUserListAll,
    SinaFollowByUserID,             //关注一个用户 by User ID
    SinaFollowByUserName,           //关注一个用户 by User Name
    SinaUnfollowByUserID,           //取消关注一个用户 by User ID
    SinaUnfollowByUserName,         //取消关注一个用户 by User Name
    SinaGetTrendStatues,            //获取某话题下的微博消息
    SinaFollowTrend,                //关注某话题
    SinaUnfollowTrend,              //取消对某话题的关注
    SinaPostText,                   //发布文字微博
    SinaPostTextAndImage,           //发布文字图片微博
    SinaGetHomeLine,                //获取当前登录用户及其所关注用户的最新微博
    SinaGetComment,                 //根据微博消息ID返回某条微博消息的评论列表
    SinaGetUserStatus,              //获取某个用户最新发表的微博列表
    SinaRepost,                     //转发一条微博
    SinaGetFollowingUserList,       //获取用户的关注列表
    SinaGetFollowedUserList,        //获取用户粉丝列表
    SinaGetHotRepostDaily,          //按天返回热门微博转发榜的微博列表
    SinaGetHotCommentDaily,         //按天返回热门微博评论榜的微博列表
    SinaGetUnreadCount,             //获取某个用户的各种消息未读数
}RequestType;

@interface TweetingViewController : UIViewController
- (IBAction)cancelBtn:(UIBarButtonItem *)sender;
- (IBAction)sendBtn:(UIBarButtonItem *)sender;
@property (retain, nonatomic) IBOutlet UITextView *textContent;

@property (retain,nonatomic) RequestEngine *requestEngine;

@end

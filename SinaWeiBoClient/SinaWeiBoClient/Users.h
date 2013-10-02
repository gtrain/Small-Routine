//
//  Users.h
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-14.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GenderUnknow = 0,
    GenderMale,
    GenderFemale,
} Gender;

@interface Users : NSObject

@property (nonatomic, assign) long long    userId; //用户UID
@property (nonatomic, assign) NSNumber		*userKey;

@property (nonatomic, assign) Gender userGender; //性别,m--男，f--女,n--未知
@property (nonatomic, assign) int    userFollowersCount; //粉丝数
@property (nonatomic, assign) int    userFriendsCount; //关注数
@property (nonatomic, assign) int    userStatusesCount; //微博数
@property (nonatomic, assign) int    userFavoritesCount; //收藏数
@property (nonatomic, assign) time_t userCreatedAt; //注册时间
@property (nonatomic, assign) BOOL   userFollowing; //是否已关注(此特性暂不支持)
@property (nonatomic, assign) BOOL   userVerified; //加V标示，是否微博认证用户
@property (nonatomic, assign) BOOL   userAllowAllActMsg; //?
@property (nonatomic, assign) BOOL   userGeoEnabled; //?

@property (nonatomic, retain) NSString  *userScreenName; //微博昵称
@property (nonatomic, retain) NSString  *name; //友好显示名称，如Bill Gates(此特性暂不支持)
@property (nonatomic, retain) NSString  *userProvince; //省份编码（参考省份编码表）
@property (nonatomic, retain) NSString  *userCity; //城市编码（参考城市编码表）
@property (nonatomic, retain) NSString  *userLocation; //地址
@property (nonatomic, retain) NSString  *userDescription; //个人描述
@property (nonatomic, retain) NSString  *userUrl; //用户博客地址

@property (retain,nonatomic) NSData *userProfilePicData;           //微博头像
@property (retain,nonatomic) NSString *userProfilePicUrl;           //微博头像链接,用string类型，方便获取数据的时候比较
@property (nonatomic, retain) NSString  *userProfileLargeImageUrl; //大图像地址

@property (nonatomic, retain) NSString  *userDomain; //用户个性化URL


+(Users *) userWithJsonDic:(NSDictionary *) dic;


@end









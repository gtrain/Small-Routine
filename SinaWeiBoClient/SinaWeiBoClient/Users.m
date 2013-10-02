//
//  Users.m
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-14.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import "Users.h"

@implementation Users
/*
-(id) initWithJsonDic:(NSDictionary *)dic{
    self=[super init];
    if () {
        
    }
    return self;
}*/


+(Users *) userWithJsonDic:(NSDictionary *) dic{
    Users *user=[[[self alloc] init] autorelease];
    
    user.userScreenName=[dic objectForKey:@"screen_name"];
    user.userProfilePicUrl=[dic objectForKey:ProfileImageUrl];
    
    //...
    return user;
}

-(void) dealloc{
    
    [super dealloc];
}

@end

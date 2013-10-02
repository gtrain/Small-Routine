//
//  UsersCoreData.h
//  SinaWeiBoClient
//
//  Created by yzq on 13-4-5.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UsersCoreData : NSManagedObject

@property (nonatomic, retain) NSString * access_token;
@property (nonatomic, retain) NSDate * expires_in;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * userName;

@end

//
//  PersonalViewController.h
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-22.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Users.h"
#import "HomeStatusCell.h"

@interface PersonalViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *statusArray;   //微博status对象数组（json解析后实例化status类）
@property (retain,nonatomic) RequestEngine *requestEngine;

@property (retain, nonatomic) IBOutlet UILabel *userName;
@property (retain, nonatomic) IBOutlet UIImageView *userProfilePic;
@property (retain, nonatomic) IBOutlet UIButton *userFollowers;
@property (retain, nonatomic) IBOutlet UIButton *userFriends;
@property (retain, nonatomic) IBOutlet UIButton *userStatusCount;
@property (retain, nonatomic) IBOutlet UILabel *userDescription;

@property (retain, nonatomic) IBOutlet UITableView *personalTableView;


@property (retain, nonatomic) IBOutlet UIBarButtonItem *refreshBtn;
- (IBAction)refresh:(UIBarButtonItem *)sender;

@end



//https://api.weibo.com/2/statuses/user_timeline.json?uid=1841185175&access_token=2.00F47bACEO2Q6E6124ec61f5X3QnGD
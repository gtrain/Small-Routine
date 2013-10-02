//
//  LoginViewController.h
//  WeiboClient_yzq
//
//  Created by yang on 13-2-8.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthViewController.h"
#import "UsersCoreData.h"


@interface LoginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic,retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;  //数据库存放方式
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;              //数据库操作
@property (nonatomic,retain) NSMutableArray *usersArray;                           //用户表数据源
@property (retain, nonatomic) IBOutlet UITableView *usersTable;


@property (nonatomic,strong) RequestEngine *requestEngine;
@property (nonatomic,strong) NSDictionary *userInfo;        //用户token等信息，从本地获取或者从网络更新

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
- (IBAction)LoginBtnPress:(UIButton *)sender;

@end

//
//  HomePageViewController.h
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-14.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeStatusCell.h"
#import "Status.h"


@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong,nonatomic) NSMutableArray *statusArray;   //微博status对象数组（json解析后实例化status类）
@property (retain,nonatomic) RequestEngine *requestEngine;


- (IBAction)refresh:(UIBarButtonItem *)sender;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *refreshBtn;

@end

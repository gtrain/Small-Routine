//
//  SettingViewController.h
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-24.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *SettingTableView;

@end

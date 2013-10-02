//
//  SettingViewController.m
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-24.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)dealloc {
    [_SettingTableView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.SettingTableView.delegate=self;
    self.SettingTableView.dataSource=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --UITableViewDataSource--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==0? 2:1;     //第一个章节只有一个关于
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row =[indexPath row];
    NSInteger section=indexPath.section;
    
    static NSString *cellIndentifier=@"SettingCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    //这里的章节跟行数应该封装成
    if (section==0) {
        if (row==0) {
            cell.textLabel.text=@"管理账号";
        }else if(row==1){
            cell.textLabel.text=@"注销登陆";
        }
    }else if(section==1){
        cell.textLabel.text=@"关于";
    }
    return cell;
}

#pragma mark --UITableViewDelegate---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0 ) {
        if (row == 1) {
            [self logout];
        }
    }
}

-(void) logout{
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* sinaweiboCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://open.weibo.cn"]];
    for (NSHTTPCookie* cookie in sinaweiboCookies)
    {
        [cookies deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_USER_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end







